/*
 * srec_file.c - Simple pocketsphinx command-line application to test
 *               continuous file transcription.
 * ------------------------------------------------------------------
 * Mihai Cirlanaru
 */

#include <stdio.h>
#include <string.h>

#include <sphinxbase/err.h>
#include <sphinxbase/ad.h>
#include <sphinxbase/cont_ad.h>

#include "pocketsphinx.h"

//#define MULTIPLE_RUNS 1

static const arg_t cont_args_def[] = {
    POCKETSPHINX_OPTIONS,
    /* Argument file. */
    { "-argfile",
      ARG_STRING,
      NULL,
      "Argument file giving extra arguments." },    
    { "-infile", 
      ARG_STRING, 
      NULL, 
      "Audio file to transcribe." },
    { "-time", 
      ARG_BOOLEAN, 
      "no", 
      "Print word times in file transcription." },
    CMDLN_EMPTY_OPTION
};

static ps_decoder_t *ps;
static cmd_ln_t *config;
static FILE* rawfd;

static void
print_word_times(int32 start)
{
	ps_seg_t *iter = ps_seg_iter(ps, NULL);
	while (iter != NULL) {
		int32 sf, ef, pprob;
		float conf;
		
		ps_seg_frames (iter, &sf, &ef);
		pprob = ps_seg_prob (iter, NULL, NULL, NULL);
		conf = logmath_exp(ps_get_logmath(ps), pprob);
		printf ("%s %f %f %f\n", ps_seg_word (iter), (sf + start) / 100.0, (ef + start) / 100.0, conf);
		iter = ps_seg_next (iter);
	}
}

/*
 * Continuous recognition from a file
 */
static void
recognize_from_file() {
    ad_rec_t file_ad = {0};
    const char* hyp;
    const char* uttid;

    rawfd = fopen(cmd_ln_str_r(config, "-infile"), "rb");
    if (rawfd == NULL) {
        E_ERROR("Cannot open audio recording!");
    } else {
        // DEBUG
        E_INFO("[DEBUG] Recognizing speech from file: %s\n", cmd_ln_str_r(config, "-infile"));
        int rv;
        int i = 0;
#ifdef MULTIPLE_RUNS    
        for (i = 0; i <= 5; i++) {
            rewind (rawfd);
#endif       
            rv = ps_decode_raw(ps, rawfd, "[RECOGNIZED]", -1);
            double out_nspeech, out_ncpu, out_nwall;

            hyp = ps_get_hyp(ps, NULL, &uttid);
            printf("%s: %s\n", uttid, hyp);
            ps_get_utt_time(ps, &out_nspeech, &out_ncpu, &out_nwall);
            E_INFO_NOFN("[TIMER %d] Speech: %.2f CPU: %.3f Recognize: %.3f x RT\n\n", i, out_nspeech, out_ncpu, out_nwall/out_nspeech);
            fflush(stdout);
#ifdef MULTIPLE_RUNS        
        }
#endif
        fclose(rawfd);
    }
}


int
main(int argc, char *argv[])
{
    char const *cfg;

    if (argc == 2) {
        config = cmd_ln_parse_file_r(NULL, cont_args_def, argv[1], TRUE);
    }
    else {
        config = cmd_ln_parse_r(NULL, cont_args_def, argc, argv, FALSE);
    }
    /* Handle argument file as -argfile. */
    if (config && (cfg = cmd_ln_str_r(config, "-argfile")) != NULL) {
        config = cmd_ln_parse_file_r(config, cont_args_def, cfg, FALSE);
    }
    if (config == NULL)
        return 1;

    ps = ps_init(config);
    if (ps == NULL)
        return 1;
    
    E_INFO("%s COMPILED ON: %s, AT: %s\n\n", argv[0], __DATE__, __TIME__);

    if (cmd_ln_str_r(config, "-infile") != NULL) {
        // DEBUG
        E_INFO("[DEBUG] Recognize from file: %s\n", cmd_ln_str_r(config, "-infile"));
	    recognize_from_file();
        
    } else {
        // DEBUG
        E_INFO("[DEBUG] NO speech file provided, use -infile argument!");

    }

    ps_free(ps);
    return 0;
}
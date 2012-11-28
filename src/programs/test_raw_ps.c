#include "pocketsphinx.h"
#define MODELDIR "/Users/mcirlanaru/Mozilla/cmusphinx/pocketsphinx-0.7/model"

int
main(int argc, char *argv[])
{
	ps_decoder_t *ps;
	cmd_ln_t *config;
	FILE *fh;
	char const *hyp, *uttid;
	int rv;

	config = cmd_ln_init(NULL, ps_args(), TRUE,
			     "-hmm",  "model/hmm/en_US/hub4wsj_sc_8k",
			     "-lm", "model/lm/en/turtle.DMP",
			     "-dict", "model/lm/en/turtle.dic",
			     NULL);
	if (config == NULL)
		return 1;
	ps = ps_init(config);
	if (ps == NULL)
		return 1;

	fh = fopen("test/data/goforward.raw", "rb");
	if (fh == NULL) {
		perror("Failed to open goforward.raw");
		return 1;
	}

	rv = ps_decode_raw(ps, fh, "goforward", -1);
	if (rv < 0)
		return 1;
	hyp = ps_get_hyp(ps, NULL, NULL);
	if (hyp == NULL)
		return 1;
	printf("Recognized: %s\n", hyp);

	fclose(fh);
  ps_free(ps);
	return 0;
}

 // Preload file arguments by overriding preRun
 Module['preRun'] = function() {
    if (typeof Module['audio_url'] === "string") {
      // received URL as argument
      FS.createPreloadedFile('/', 'recording.raw', Module['audio_url'], true, false);
    } else {
      // received byte array
      FS.createDataFile('/', 'recording.raw', Module['raw'], true, false);
    }

    FS.createPreloadedFile('/', 'mdef', Module['mdef'], true, false);
    FS.createPreloadedFile('/', 'tmat', Module['tmat'], true, false);
    FS.createPreloadedFile('/', 'variances', Module['variances'], true, false);
    FS.createPreloadedFile('/', 'sendump', Module['sendump'], true, false);
    FS.createPreloadedFile('/', 'feat.params', Module['fparams'], true, false);
    FS.createPreloadedFile('/', 'means', Module['mean'], true, false);
    if (typeof Module['fsg'] != "undefined") {
      FS.createPreloadedFile('/', 'model.fsg', Module['fsg'], true, false);
    } else {
      FS.createPreloadedFile('/', 'model.DMP', Module['DMP'], true, false);
    }
    FS.createPreloadedFile('/', 'model.dic', Module['dic'], true, false);
    console.log("FINISHED LOADING FILES");
  };
var LMarg = "-lm model.DMP";
if (typeof Module['fsg'] != "undefined") {
  LMarg = "-fsg model.fsg";
  console.log("USING FINITE STATE GRAMMAR (FSG)");
}
var args = "-infile recording.raw -mdef mdef -tmat tmat -mean means -sendump sendump -featparams feat.params -var variances -dict model.dic " + LMarg + " -samprate " + Module["samprate"] + " -nbest " + Module["nbest"];
Module['arguments'] = args.split(" ");

Module['return'] = '';
srecRegExp=/\[RECOGNIZED\]: (.*)/g;
srecNRegExp=/\[NBEST\]: (.*)/g;
timerRegExp=/.*\[TIMER \w\] (.*)/g;

Module['print'] = function(text) {
  Module['return'] += text + '\n';
  console.log(text);

  if (text.match(srecRegExp)) {
    document.getElementById("srec_hyp").innerHTML = srecRegExp.exec(text)[1];
  } else
  if (text.match(srecNRegExp)) {
    document.getElementById("srec_hyp_nbest").innerHTML += srecNRegExp.exec(text)[1] + "<br/>";
  } else
  if (text.match(timerRegExp)) {
    document.getElementById("srec_timer").innerHTML = "TIME: "+ timerRegExp.exec(text)[1];
  }
};
vid = videoinput('hamamatsuadaptorimaq', 1, 'MONO16_2048x2048_FastMode');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

preview(vid);

src.ExposureTime = 0.04;

src.OutputTriggerKindOpt1 = 'exposure';
src.OutputTriggerKindOpt2 = 'programable';
stoppreview(vid);

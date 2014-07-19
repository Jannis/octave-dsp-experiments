function generate_audio(bits, samplerate)
  if not(isdir('audio'))
    mkdir('audio');
  end

  generate_sinewaves(bits, samplerate, 220);
end


function generate_sinewaves(bits, samplerate, frequency)
  utils = utilities;

  sample_points = utils.samplepoints(5000, samplerate);

  fprintf(1, 'generate regular sin waves\n');

  for db = 0:-6:-12
    samples = utils.db2amplitude(db) \
            * utils.sinewave(sample_points, samplerate, frequency);

    fprintf(1, '  dB: %3i | dB factor: %0.2f\n', db, utils.db2amplitude(db));
    fprintf(1, '    max: %i | min: %i\n', max(samples), min(samples));

    filename = sprintf('audio/sin_%idB.wav', db);
    wavwrite(samples, samplerate, bits, filename);
  end

  fprintf(1, '\n');
  fprintf(1, 'generate dB jumps\n');

  db_jumps = [
    -18 -12 -18
    -12  -6 -12
     -6  -3  -6
    -18  -6 -18
    -12  -3 -12
     -6   0  -6
  ];

  for i = 1:size(db_jumps)
    db_jump = db_jumps(i, :);
    amplitudes = utils.db2amplitude(db_jump);

    samples = [
      amplitudes(1) * utils.sinewave(sample_points, samplerate, frequency, 0, 1000)
      amplitudes(2) * utils.sinewave(sample_points, samplerate, frequency, 1000, 2000)
      amplitudes(3) * utils.sinewave(sample_points, samplerate, frequency, 2000, 5000)
    ];

    fprintf(1, '  dB low: %3i (factor %0.2f) | dB high: %3i (factor %0.2f)\n',
            db_jump(1), amplitudes(1), db_jump(2), amplitudes(2));

    filename = sprintf('audio/sin_%idB_to_%idB.wav', db_jump(1), db_jump(2));
    wavwrite(samples, samplerate, bits, filename);
  end

  fprintf(1, '\n');
end

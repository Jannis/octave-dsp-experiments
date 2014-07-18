bits = 16
samplerate = 44100
threshold = -6

global bits samplerate threshold



% function to calculate the dB of a sample
function db = sample2db(x)
  db = 20 .* log10(x / 1.0);
end



function x = db2sample(db)
  x = 10 .^ (db ./ 20.0) .* 1.0;
end



audio_files = dir(fullfile('audio', '*.wav'));



function samples = compress(in)
  global bits samplerate threshold

  samples = in;
  
  for i = 1:length(samples)
    if sample2db(abs(samples(i))) > threshold
      samples(i) = sign(samples(i)) * db2sample(threshold);
    end
  end
end



if not(isdir('audio_compressed'))
  mkdir('audio_compressed');
end



for i = 1:length(audio_files)
  source = audio_files(i);
  fprintf(1, 'compress %s\n', source.name);
  fflush(1);

  in = wavread(fullfile('audio', source.name));
  out = compress(in);

  filename = fullfile('audio_compressed', source.name);
  wavwrite(out, samplerate, bits, filename);
end

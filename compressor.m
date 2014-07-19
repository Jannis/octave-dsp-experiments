function comp = compressor
  comp.settings = @compressor_settings;
  comp.compress_files = @compress_files;
end


function s = compressor_settings
  s = struct(
    'threshold', 0,
    'ratio', 1
  );
end


function compress_files(files, settings, bits, samplerate)
  if not(isdir('audio_compressed'))
    mkdir('audio_compressed');
  end

  for i = 1:length(files)
    input_filename = files{i};
    [path, name, ext] = fileparts(input_filename);
    output_filename = fullfile('audio_compressed', [name ext]);

    compress_file(input_filename, output_filename, settings,
                  bits, samplerate);
  end
end


function compress_file(input_file, output_file, settings, bits, samplerate)
  fprintf(1, 'compress file %s -> %s\n', input_file, output_file);
  fflush(1);
  in = wavread(input_file);
  out = compress_samples(in, settings);
  wavwrite(out, samplerate, bits, output_file);
end


function out = compress_samples(in, settings)
  ratio = 1 / double(max(settings.ratio, 1.0));

  out = zeros(size(in));
  for i = 1:length(in)
    if utilities.amplitude2db(abs(in(i))) > settings.threshold
      out(i) = ratio * in(i);
    else
      out(i) = in(i);
    end
  end
end


%bits = 16
%samplerate = 44100
%threshold = -6
%
%global bits samplerate threshold
%
%
%
%% function to calculate the dB of a sample
%function db = sample2db(x)
%  db = 20 .* log10(x / 1.0);
%end
%
%
%
%function x = db2sample(db)
%  x = 10 .^ (db ./ 20.0) .* 1.0;
%end
%
%
%
%audio_files = dir(fullfile('audio', '*.wav'));
%
%
%
%function samples = compress(in)
%  global bits samplerate threshold
%
%  samples = in;
%  
%  for i = 1:length(samples)
%    if sample2db(abs(samples(i))) > threshold
%      samples(i) = sign(samples(i)) * db2sample(threshold);
%    end
%  end
%end
%
%
%
%if not(isdir('audio_compressed'))
%  mkdir('audio_compressed');
%end
%
%
%
%for i = 1:length(audio_files)
%  source = audio_files(i);
%  fprintf(1, 'compress %s\n', source.name);
%  fflush(1);
%
%  in = wavread(fullfile('audio', source.name));
%  out = compress(in);
%
%  filename = fullfile('audio_compressed', source.name);
%  wavwrite(out, samplerate, bits, filename);
%end

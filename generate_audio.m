% function to calculate factor to boost/attenuate a sample
% by a certain amount of dB
db2factor = @(db) 10 .^ (db ./ 20.0) .* 1.0;



bits = 16;
samplerate = 44100;
seconds = 5;
frequency = 220;

sample_points = linspace(0, seconds, seconds * samplerate);


global bits samplerate seconds frequency sample_points


% function to generate sin for a time range given in seconds
function samples = sin4seconds(from, to)
  global bits samplerate seconds frequency sample_points

  if nargin < 2
    to = seconds;
  end
  if nargin < 1
    from = 0;
  end

  from = from * samplerate + 1;
  to = to * samplerate;

  samples = sin(2 .* pi .* frequency .* sample_points(from:to));
end



if not(isdir('audio'))
  mkdir('audio');
end



fprintf(1, 'generate regular sin waves\n');

for db = 0:-6:-12
  fprintf(1, '  dB: %3i | dB factor: %0.2f\n', db, db2factor(db));

  samples = db2factor(db) * sin4seconds();

  fprintf(1, '    max: %i | min: %i\n', max(samples), min(samples));

  filename = sprintf('audio/sin_%idB.wav', db);
  wavwrite(samples', samplerate, bits, filename)
end

fprintf(1, '\n');



fprintf(1, 'generate dB jumps\n');

db_jumps = [-18 -12; -12 -6; -6 -3; -18 -6; -12 -3; -6 0];
for i = 1:size(db_jumps)
  db_jump = db_jumps(i, :);

  db_factors = db2factor(db_jump);
  fprintf(1, '  dB low: %3i (factor %0.2f) | dB high: %3i (factor %0.2f)\n',
          db_jump(1), db_factors(1), db_jump(2), db_factors(2));

  samples1 = db_factors(1) * sin4seconds(0, 1);
  samples2 = db_factors(2) * sin4seconds(1, 2);
  samples3 = db_factors(1) * sin4seconds(2, 5);

  samples = [samples1 samples2 samples3];

  filename = sprintf('audio/sin_%idB_to_%idB.wav', db_jump(1), db_jump(2));
  wavwrite(samples', samplerate, bits, filename);
end

fprintf(1, '\n');

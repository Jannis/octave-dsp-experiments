function utils = utilities
  utils.amplitude2db = @amplitude2db;
  utils.db2amplitude = @db2amplitude;
  utils.samplepoints = @samplepoints;
  utils.sinewave = @sinewave;
end


% convert an amplitude/sample value to dB
function db = amplitude2db(x)
  db = 20 .* log10(x ./ 1.0);
end


% convert a dB value to the corresponding amplitude/sample value
function x = db2amplitude(db)
  x = 10 .^ (db ./ 20.0) .* 1.0;
end


% generate sample points for a given duration span (in milliseconds)
% and sample rate (in Hz)
function points = samplepoints(duration, samplerate)
  points = linspace(0, duration / 1000, duration / 1000 * samplerate);
end


% generate a sine wave for a given frequency, a sequence of sample
% points and a time span relative to these sample points
function samples = sinewave(points, samplerate, frequency, from, to)
  if nargin < 4; from = 0; end
  if nargin < 5; to = length(points) / samplerate * 1000; end

  first = from / 1000 * samplerate + 1;
  last = to / 1000 * samplerate;

  samples = sin(2 .* pi .* frequency .* points(first:last))';
end

function test_compression
  files = generate_audio(32, 44100);

  settings = compressor.settings();
  settings.threshold = -6;
  settings.ratio = 2;

  compressor.compress_files(files, settings, 32, 44100);
end

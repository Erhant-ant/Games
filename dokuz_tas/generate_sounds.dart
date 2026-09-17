import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void generateWav(String filename, double duration, double Function(double) freqFunc, double Function(double) volFunc) {
  int sampleRate = 44100;
  int numSamples = (duration * sampleRate).toInt();
  
  var file = File(filename);
  file.createSync(recursive: true);
  var builder = BytesBuilder();
  
  // RIFF header
  builder.add('RIFF'.codeUnits);
  builder.add((36 + numSamples * 2).toBytes(4));
  builder.add('WAVE'.codeUnits);
  
  // fmt chunk
  builder.add('fmt '.codeUnits);
  builder.add(16.toBytes(4)); // chunk size
  builder.add(1.toBytes(2)); // PCM
  builder.add(1.toBytes(2)); // mono
  builder.add(sampleRate.toBytes(4));
  builder.add((sampleRate * 2).toBytes(4)); // byte rate
  builder.add(2.toBytes(2)); // block align
  builder.add(16.toBytes(2)); // bits per sample
  
  // data chunk
  builder.add('data'.codeUnits);
  builder.add((numSamples * 2).toBytes(4));
  
  for (int i = 0; i < numSamples; i++) {
    double t = i / sampleRate;
    double freq = freqFunc(t);
    double vol = volFunc(t);
    
    int value = (vol * 32767.0 * sin(2.0 * pi * freq * t)).toInt();
    builder.add(value.toBytes(2));
  }
  
  file.writeAsBytesSync(builder.toBytes());
}

extension IntBytes on int {
  List<int> toBytes(int length) {
    var result = <int>[];
    for (int i = 0; i < length; i++) {
      result.add((this >> (i * 8)) & 0xFF);
    }
    return result;
  }
}

void main() {
  Directory('assets/audio').createSync(recursive: true);
  
  generateWav('assets/audio/place.wav', 0.15, (t) => 150.0 + (100.0 * exp(-t * 20)), (t) => exp(-t * 30));
  generateWav('assets/audio/capture.wav', 0.25, (t) => 400.0, (t) => exp(-t * 15) * 0.8);
  generateWav('assets/audio/mill.wav', 0.5, (t) => 800.0 + (200.0 * sin(t * 20)), (t) => exp(-t * 5) * 0.5);
  
  print('Sounds generated!');
}

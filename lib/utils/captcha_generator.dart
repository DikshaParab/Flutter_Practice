import 'dart:math';

String generateCaptcha() {
  const upperChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lowerChars = 'abcdefghijklmnopqrstuvwxyz';
  const digiChars = '1234567890';

  final random = Random();
  
  final chars = <String>[
    ...List.generate(2,(_) => upperChars[random.nextInt(upperChars.length)]),
    ...List.generate(2,(_) => digiChars[random.nextInt(digiChars.length)]),
    ...List.generate(2,(_) => lowerChars[random.nextInt(lowerChars.length)]),
  ];

  chars.shuffle(random);
  
  return chars.join();
}
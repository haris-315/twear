double responsiveWidth(double screenWidth) {
  if (screenWidth <= 320) {
    return screenWidth * 0.9; // Tiny screens (compact phones)
  } else if (screenWidth <= 480) {
    return screenWidth * 0.55; // Small phones
  } else if (screenWidth <= 600) {
    return screenWidth * 0.43; // Large phones
  } else if (screenWidth <= 768) {
    return screenWidth * 0.4; // Small tablets
  } else if (screenWidth <= 1024) {
    return screenWidth * 0.3; // Large tablets & small laptops
  } else if (screenWidth <= 1366) {
    return screenWidth * 0.2; // Standard laptops
  } else {
    return screenWidth * 0.18; // Large desktop screens
  }
}



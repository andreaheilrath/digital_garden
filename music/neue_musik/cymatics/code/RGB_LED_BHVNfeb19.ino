int R_PIN = 9;
int G_PIN = 10;
int B_PIN = 11;

float Volt = 0;
float VoltMemory = 0;
float VoltMemoryWeight = 77;
float Threshold = 1;
int AudioPin = 13;

float period = 5000.0; // in millis



// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(R_PIN, OUTPUT);
  pinMode(G_PIN, OUTPUT);
  pinMode(B_PIN, OUTPUT);
  pinMode(13, OUTPUT);
  Serial.begin(9600);
}


// the loop function runs over and over again forever
void loop() {

  float sensorValue = analogRead(A0);
  float volts = 5 * sensorValue / 1023.0;
  VoltMemory = (VoltMemoryWeight * VoltMemory + volts) / (1 + VoltMemoryWeight);

  if (VoltMemory > Threshold) {
    analogWrite(R_PIN, 255);
    analogWrite(G_PIN, 12);
    analogWrite(B_PIN, 0);
    digitalWrite(13, HIGH);
  }
  else {
    analogWrite(R_PIN, 0);
    analogWrite(G_PIN, 0);
    analogWrite(B_PIN, 0);
    digitalWrite(13, LOW);
  }

  //  float hue;
  //  hue = 360.0*((millis()%int(period))/period);
  //  //hue = 100;
  //  analogWrite(R_PIN, HSVtoRGB('R', hue));  //analogWrite values from 0 to 255
  //  analogWrite(G_PIN, HSVtoRGB('G', hue));  //analogWrite values from 0 to 255
  //  analogWrite(B_PIN, HSVtoRGB('B', hue));  //analogWrite values from 0 to 255
}




int HSVtoRGB(char led_color, float H) {
  float phase;
  if (led_color == 'G') phase = 0.0;
  else {
    if (led_color == 'B') phase = 360.0 - 120.0;
    else {
      if (led_color == 'R') phase = 360.0 - 240.0;
      else {
        Serial.println("Error, no RGB char detected");
        return (0);
      }
    }
  }

  float alpha = fmod(H + phase, 360.0);
  if (alpha < 60) return ((255.0 * (alpha / 60.0)) + 0.5);
  else {
    if (alpha < 180) return (255);
    else {
      if (alpha < 240) return (255 - (255.0 * (alpha - 180) / 60.0) + 0.5);
      else {
        if (alpha < 360.001) return 0;
      }
    }
  }
}


int Sine_HSVtoRGB(char led_color, float H) {
  float phase;
  if (led_color == 'G') phase = 0.0;
  else {
    if (led_color == 'B') phase = 360.0 - 120.0;
    else {
      if (led_color == 'R') phase = 360.0 - 240.0;
      else {
        Serial.println("Error, no RGB char detected");
        return (0);
      }
    }
  }

  float alpha = fmod(H + phase, 360.0);
  return 0.5 + 255.0 * (0.5 + 0.5 * sin(-PI / 2 + 2 * PI * alpha / 360.0));
}

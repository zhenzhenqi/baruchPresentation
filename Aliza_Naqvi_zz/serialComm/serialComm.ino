
const int SENSOR_PIN = 0;      // Analog input pin

void setup()
{
  Serial.begin(9600);
  // No need for any code here
  // analogWrite() sets up the pins as outputs
}


void loop()
{
  int sensorValue;
  //
  //  // Read the voltage from the softpot (0-1023)
  //
  sensorValue = analogRead(A0);
   Serial.write(map(sensorValue,0,1024,255,0));
//  Serial.write(map(sensorValue, 0, 1024, 255, 0));
  delay(100);
}




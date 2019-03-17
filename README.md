The Inebriator is a cocktail machine able to serve several recipes from a web interface.

![Photo](https://i.ibb.co/G76jqmb/IMG-0576.jpg)

## How it works :

The last version is based on a ESP8266 (IOT device). It host a simple http server to display a web interface :    
[![Capture-d-cran-2019-03-17-08-25-19.png](https://i.postimg.cc/WzyFcBj1/Capture-d-cran-2019-03-17-08-25-19.png)](https://postimg.cc/jnzdzkLp)

Once the cocktail is selected, the ESP8266 will control the 2 stepper motors and the servomotor to serve the cocktail.   
The glass is put on the lift and will rotate over the bottles to be filled by both hard and soft beverages.  

Last stable version is https://github.com/tilaktilak/Inebriator/tree/LUA   

## Pinout on ESP8266


| PIN           | FUNCTION      | PIN     |
| ------------- |:-------------:| -------:|
|D1             | M1            | ENABLE  |
|D2             | M1            |   STEP  |
|D3             | M1            | DIR     |
|D4             | M2            | ENABLE  |
|D5             | M2            | STEP    |
|D6             | M2            | DIR     |
|D7             | PWM           | SERVO   |
|D8             | EOC           | PLATE   |
|A0             | EOC           | LIFT    |


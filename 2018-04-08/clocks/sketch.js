function getHourInTimezone(hour, offset) {
    const hoursPerDay = 24;
    const result = (hour + offset) % hoursPerDay;
    if (result < 0) {
	return result + hoursPerDay;
    }
    return result;
}

function clocks (position, hAmerica) {
 

    // Draw the clock background
    noStroke();
    fill(244, 122, 158);
    ellipse(position, cy, clockDiameter + 25, clockDiameter + 25);
    fill(237, 34, 93);
    ellipse(position, cy, clockDiameter, clockDiameter);
  
    // Angles for sin() and cos() start at 3 o'clock;
    // subtract HALF_PI to make them start at the top
    let s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
    let m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
    let h = map(getHourInTimezone(hour(), hAmerica) - norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
    

    
    
  
    // Draw the hands of the clock
    stroke(255);
    strokeWeight(1);
    line(position, cy, position + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
    strokeWeight(2);
    line(position, cy, position + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
    strokeWeight(4);
    line(position, cy, position + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
    
    
  
    // Draw the minute ticks
    strokeWeight(2);
    beginShape(POINTS);
    for (let a = 0; a < 360; a += 6) {
      let angle = radians(a);
      let x = position + cos(angle) * secondsRadius;
      let y = cy + sin(angle) * secondsRadius;
      vertex(x, y);
    }
    endShape();
}


let cx, cy;
let secondsRadius;
let minutesRadius;
let hoursRadius;
let clockDiameter;

function setup() {
  createCanvas(1400, 400);
  stroke(255);

  let radius = min(width, height) /2;
  secondsRadius = radius * 0.70;
  minutesRadius = radius * 0.6;
  hoursRadius = radius * 0.8;
  clockDiameter = radius * 1.7;

  cx = width / 4;
  cAmerica = width * 0.75;
  cy = height / 2;
}



function draw() {
    background(230);
clocks (cx, 0);
clocks (cAmerica, -6); 
}

//SECOND CLOCK


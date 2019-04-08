function setup() {
  createCanvas(400, 400).parent("wrapper");
}

function draw() {
  for (var radius = 400; radius > 0; radius -= 20) {
    ellipse(200, 200, radius, radius);
  }
}

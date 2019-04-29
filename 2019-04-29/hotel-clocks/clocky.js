class Clocky {
    constructor(tempX, tempTimeZone, tempCity, color) {
        this.x = tempX;
        this.y = (height / 2) - 25;
        this.radius = min(windowWidth, height - 150) / 2;
        //this.color = tempColor;
        this.timeZone = tempTimeZone;
        this.city = tempCity;
        this.color = color;
    }

    makeIt() {
      let innerColor = this.color;
      innerColor.setAlpha(100);
      let outerColor = innerColor;
      outerColor.setAlpha(50);
      fill(outerColor);
        //noStroke();
      ellipse(this.x, this.y, this.radius * 2 + 20);
        fill(innerColor);
        //fill((116/random(1,116)), (204/random(1,204)), (145/random(1,145)));
        //fill(this.color[0],this.color[1],this.color[2]); How to work with arrays in the class?
        ellipse(this.x, this.y, this.radius * 2);
    }

    makeHands() {
        let lineColor = this.color;
        lineColor.setAlpha(250);
        var s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI; //segundos, arranca en 0 hasta 60, quiero que vaya de 0 a 2PI (360 grados)
        var m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; //idem arriba, contemplando los segundos en el minuto
        var h = map(getHourInTimezone(hour(), this.timeZone) + norm(minute(), 0, 60), 0, 24, 0, 2 * TWO_PI) - HALF_PI; //en este caso va de 0 a 24, y da dos vueltas, por lo que 2 * 2PI

        stroke(lineColor);
        strokeWeight(1);
        line(this.x, this.y, this.x + this.radius * 0.9 * cos(s), this.y + this.radius * 0.9 * sin(s));
        strokeWeight(2);
        line(this.x, this.y, this.x + this.radius * 0.85 * cos(m), this.y + this.radius * 0.85 * sin(m));
        strokeWeight(4);
        line(this.x, this.y, this.x + this.radius * 0.75 * cos(h), this.y + this.radius * 0.75 * sin(h));
    }

    makeDots() {
        fill(255);
        stroke(255);

        for (var a = 0; a < TWO_PI; a += HALF_PI) {
            var x = this.x + 0.9 * this.radius * cos(a);
            var y = this.y + 0.9 * this.radius * sin(a);
            var xf = this.x + 0.97 * this.radius * cos(a);
            var yf = this.y + 0.97 * this.radius * sin(a);
            line(x, y, xf, yf);
        }

        beginShape(POINTS);
        for (var a = 0; a < 360; a += 30) {
            var angle = radians(a);
            var x = this.x + this.radius * cos(angle) * 0.95;
            var y = this.y + this.radius * sin(angle) * 0.95;
            vertex(x, y);
        }
        endShape();
    }

    place() {
        fill(0);
        noStroke();
        textAlign(CENTER, CENTER);
        textSize(30);
        text(this.city, this.x, this.y + this.radius + 50);
    }

    drawIt() {
      this.makeIt();
      this.makeHands();
      this.makeDots();
      this.place();
    }
}

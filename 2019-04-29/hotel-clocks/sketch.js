//var innerColor,externColor;
//let clocky1, clocky2;
let clocky = [];
var showTwoClocks = 1;

// if i want to change the color of the button once it is pressed... Should I do that with css?

var yes = document.getElementById("yes").addEventListener("click", function() {
    showTwoClocks = 1;
    console.log(showTwoClocks);
});
var no = document.getElementById("no").addEventListener("click", function() {
    showTwoClocks = 0;
    console.log(showTwoClocks);
});


function setup() {
    var canvas = createCanvas(windowWidth, 500);
    h4=createElement("h4","Click the Mouse");
    h4.position(30, 50);
    clocky[0] = new Clocky(windowWidth / 4, 0, "Berlin", color(200, 30, 4));
    clocky[1] = new Clocky(windowWidth / 4 * 3, -5, "Buenos Aires", color(100, 200, 50));
    canvas.parent('sketch-holder');
}

//WHY is this not working outside setup() ???
// let h4 = createElement("h4", "Click the Mouse");
// h4.position(windowWidth / 2, 300);

function mousePressed() {
    h4.html("Cool. You've clicked.");
}

function getHourInTimezone(hour, offset) {
    const hoursPerDay = 24;
    const result = (hour + offset) % hoursPerDay;
    if (result < 0) {
        return result + hoursPerDay;
    }
    return result;
}

function infoOfTheDay() {
    fill(237, 237, 237);
    fill(0);
    noStroke();
    textFont('Georgia');
    textAlign(CENTER, CENTER);
    textSize(33);
    text("¡son las " + hour() + "!", (windowWidth - 175) / 2 + (175 / 2), 20 + (175 / 6));

    textSize(18);
    var monthName = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'Oktober', 'November', 'December'];
    text(String(day()).padStart(2, "0") + " " + monthName[month() - 1] + " " + year(), windowWidth / 2, clocky[0].y + clocky[0].radius + 50);

    textAlign(LEFT, LEFT);
    text("relojes de mundos", (windowWidth - 175) / 2 + 7, 100);
    text("Hora: " + hour(), (windowWidth - 175) / 2 + 7, 130);
    text("Minutos: " + minute(), (windowWidth - 175) / 2 + 7, 150);
    text("Segundos: " + second(), (windowWidth - 175) / 2 + 7, 170);

    //console.log("info");
}

//Trying to do color with variables, but I believe is taking only the first parameter
// var innerColor1 = (116, 204, 145);
// var externColor1 = (171, 211, 184);
// var innerColor2 = (237, 104, 104);
// var externColor2 = (211, 139, 139);

//WHY IS THIS NOT WORKIIIING? IT LOGS "holis" BUT IT WON'T SHOW infoOfTheDay() (it is calling at least)
// function mousePressed() {
//     infoOfTheDay();
//     console.log("holis")
// }

function draw() {
    background(240);
    // clear();
    infoOfTheDay();

    //CONSLUSION with the red circle: if I define the position relative to the windowWidth it will only
    //change the position of the element if it is defined inside draw(). If it is defined before,
    //like the clocks, it will be defined by the moment the page loads.
    fill(255, 0, 0);
    ellipse(windowWidth / 2, 250, 70);
    //This is way I've draw a red circle.

    if (showTwoClocks === 1) {
        for (let i = 0; i < clocky.length; i++) {
            clocky[i].makeIt();
            clocky[i].makeHands();
            clocky[i].makeDots();
            clocky[i].place();
        }
    } else {
        clocky[0].makeIt();
        clocky[0].makeHands();
        clocky[0].makeDots();
        clocky[0].place();
    }
}

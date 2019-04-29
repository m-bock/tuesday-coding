function setup() { 
  createCanvas(200, 200).parent("wrapper");
  console.log(CENTER);
} 


function trys(){
  console.log("holis");
  alert ("eeeaaa");
  print("acá hacemos un print");
}

function circle(x,y,r) {
  ellipse(x,y,r,r);
}


function draw() {  
  background(100);
  fill(frameCount%150, frameCount%15, frameCount%86);
  noStroke();
  var radius = (sin(frameCount/70)+1)*50;
  var x = (sin(frameCount/70)+1)*50;
  circle(x,100,radius);
  fill(0);
  text("hola", 100,100);
  textAlign(CENTER,CENTER);
  textSize(frameCount%50);

}



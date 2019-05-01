new p5(function(p) {
  let img;
  p.preload = () => {
    img = p.loadImage("https://picsum.photos/id/36/200/300.jpg");
  };

  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight);
    p.image(img, 0, 0);
  };

  p.draw = () => {
    //p.background(200);
  };
});

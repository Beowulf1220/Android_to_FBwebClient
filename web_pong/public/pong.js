// select canvas element
const canvas = document.getElementById("pong");

// getContext of canvas = methods and properties to draw and do a lot of thing to the canvas
const ctx = canvas.getContext('2d');

//Firebase data - players' positions
let player1Aceleration = firebase.database().ref("Pong").child("Player1").child("aceleration");
let player2Aceleration = firebase.database().ref("Pong").child("Player2").child("aceleration");

let p1a = 1;
let p2a = 1;

player1Aceleration.on('value', (snap) => {
  p1a = parseFloat(snap.val());
});

player2Aceleration.on('value', (snap) => {
  p2a = parseFloat(snap.val());
});

//info
let info1 = document.getElementById("info1");
let info2 = document.getElementById("info2");

// load sounds
let hit = new Audio();
let wall = new Audio();
let player1Score = new Audio();
let player2Score = new Audio();

hit.src = "sounds/hit.mp3";
wall.src = "sounds/wall.mp3";
player1Score.src = "sounds/comScore.mp3";
player2Score.src = "sounds/userScore.mp3";

// Ball object
const ball = {
    x : canvas.width/2,
    y : canvas.height/2,
    radius : 10,
    velocityX : 5,
    velocityY : 5,
    speed : 7,
    color : "RED"
}

// User Paddle
const player1 = {
    x : 0, // left side of canvas
    y : (canvas.height - 100)/2, // -100 the height of paddle
    width : 10,
    height : 100,
    score : 0,
    color : "GREEN"
}

// COM Paddle
const player2 = {
    x : canvas.width - 10, // - width of paddle
    y : (canvas.height - 100)/2, // -100 the height of paddle
    width : 10,
    height : 100,
    score : 0,
    color : "purple"
}

// NET
const net = {
    x : (canvas.width - 2)/2,
    y : 0,
    height : 10,
    width : 2,
    color : "BLUE"
}

// draw a rectangle, will be used to draw paddles
function drawRect(x, y, w, h, color){
    ctx.fillStyle = color;
    ctx.fillRect(x, y, w, h);
}

// draw circle, will be used to draw the ball
function drawArc(x, y, r, color){
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x,y,r,0,Math.PI*2,true);
    ctx.closePath();
    ctx.fill();
}
/*
// listening to the mouse
canvas.addEventListener("mousemove", getPlayersPos);

function getPlayersPos(){
    let rect = canvas.getBoundingClientRect();
    player1.y = (p1a * 100) + rect.top - player1.height/2;
}*/

// when COM or USER scores, we reset the ball
function resetBall(){
    ball.x = canvas.width/2;
    ball.y = canvas.height/2;
    ball.velocityX = -ball.velocityX;
    ball.speed = 7;
}

// draw the net
function drawNet(){
    for(let i = 0; i <= canvas.height; i+=15){
        drawRect(net.x, net.y + i, net.width, net.height, net.color);
    }
}

// draw text
function drawText(text,x,y){
    ctx.fillStyle = "#FFF";
    ctx.font = "75px fantasy";
    ctx.fillText(text, x, y);
}

// collision detection
function collision(b,p){
    p.top = p.y;
    p.bottom = p.y + p.height;
    p.left = p.x;
    p.right = p.x + p.width;

    b.top = b.y - b.radius;
    b.bottom = b.y + b.radius;
    b.left = b.x - b.radius;
    b.right = b.x + b.radius;

    return p.left < b.right && p.top < b.bottom && p.right > b.left && p.bottom > b.top;
}

// update function, the function that does all calculations
function update(){

	let rect = canvas.getBoundingClientRect();
    player1.y = (p1a * 100) + rect.top - player1.height/2;
    player2.y = (p1a * 100) + rect.top - player2.height/2;

    // change the score of players, if the ball goes to the left "ball.x<0" computer win, else if "ball.x > canvas.width" the user win
    if( ball.x - ball.radius < 0 ){
        player2.score++;
        player2Score.play();
        resetBall();
    }else if( ball.x + ball.radius > canvas.width){
        player1.score++;
        player1Score.play();
        resetBall();
    }

    // the ball has a velocity
    ball.x += ball.velocityX;
    ball.y += ball.velocityY;

    // computer plays for itself, and we must be able to beat it
    // simple AI
    //player2.y += ((ball.y - (player2.y + player2.height/2)))*0.1;

    // when the ball collides with bottom and top walls we inverse the y velocity.
    if(ball.y - ball.radius < 0 || ball.y + ball.radius > canvas.height){
        ball.velocityY = -ball.velocityY;
        wall.play();
    }

    // we check if the paddle hit the user or the com paddle
    let player = (ball.x + ball.radius < canvas.width/2) ? player1 : player2;

    // if the ball hits a paddle
    if(collision(ball,player)){
        // play sound
        hit.play();
        // we check where the ball hits the paddle
        let collidePoint = (ball.y - (player.y + player.height/2));
        // normalize the value of collidePoint, we need to get numbers between -1 and 1.
        // -player.height/2 < collide Point < player.height/2
        collidePoint = collidePoint / (player.height/2);

        // when the ball hits the top of a paddle we want the ball, to take a -45degees angle
        // when the ball hits the center of the paddle we want the ball to take a 0degrees angle
        // when the ball hits the bottom of the paddle we want the ball to take a 45degrees
        // Math.PI/4 = 45degrees
        let angleRad = (Math.PI/4) * collidePoint;

        // change the X and Y velocity direction
        let direction = (ball.x + ball.radius < canvas.width/2) ? 1 : -1;
        ball.velocityX = direction * ball.speed * Math.cos(angleRad);
        ball.velocityY = ball.speed * Math.sin(angleRad);

        // speed up the ball everytime a paddle hits it.
        ball.speed += 0.1;
    }
}

// render function, the function that does al the drawing
function render(){

    // clear the canvas
    drawRect(0, 0, canvas.width, canvas.height, "#000");

    // draw the user score to the left
    drawText(player1.score,canvas.width/4,canvas.height/5);

    // draw the COM score to the right
    drawText(player2.score,3*canvas.width/4,canvas.height/5);

    // draw the net
    drawNet();

    // draw the user's paddle
    drawRect(player1.x, player1.y, player1.width, player1.height, player1.color);

    // draw the COM's paddle
    drawRect(player2.x, player2.y, player2.width, player2.height, player2.color);

    // draw the ball
    drawArc(ball.x, ball.y, ball.radius, ball.color);
}
function game(){
    update();
    render();
    info1.innerHTML = `Player 1: ${p1a}`;
    info2.innerHTML = `Player 2: ${p2a}`;
}
// number of frames per second
let framePerSecond = 50;

//call the game function 50 times every 1 Sec
let loop = setInterval(game,1000/framePerSecond);
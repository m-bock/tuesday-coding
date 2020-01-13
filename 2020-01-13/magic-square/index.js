
function next(n, x) {
    return (x + 1) % n
}

function solveMagicSquare(n) {
    const grid = initialize(n);
    let x = (n - 1) / 2;
    let y = 0;

    for (let i = 1; i <= (n * n); i++) {
        grid[x][y] = i;

        const testX = next(n, x);
        const testY = next(n, next(n, y));

        if (grid[testX][testY] === 0) {
            x = testX
            y = testY
        } else {
            y = next(n, y)
        }

    }

    return grid;
}

function initialize(n) {
    const rows = [];

    for (let y = 0; y < n; y++) {
        const row = [];
        for (let x = 0; x < n; x++) {
            row[x] = 0;
        }
        rows[y] = row;
    }

    return rows;
}

function printMagicSquare(grid) {
    const n = grid.length;

    const grid2 = initialize(n);

    for (let x = 0; x < n; x++) {
        for (let y = 0; y < n; y++) {
            grid2[y][x] = grid[x][y]
        }
    }

    grid2.forEach(row => {
        console.log(row)
    });
}

function main() {
    const n = 9;
    const grid = solveMagicSquare(n);
    printMagicSquare(grid);
}

main()

module.exports = { next }
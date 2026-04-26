const express = require('express');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.post('/api/calculate', (req, res) => {
    const { num1, num2, operation } = req.body;

    if (num1 === undefined || num2 === undefined || !operation) {
        return res.status(400).json({ error: 'Missing parameters' });
    }

    const n1 = parseFloat(num1);
    const n2 = parseFloat(num2);

    if (isNaN(n1) || isNaN(n2)) {
        return res.status(400).json({ error: 'Invalid numbers' });
    }

    let result;
    switch (operation) {
        case 'add':
            result = n1 + n2;
            break;
        case 'subtract':
            result = n1 - n2;
            break;
        case 'multiply':
            result = n1 * n2;
            break;
        case 'divide':
            if (n2 === 0) {
                return res.status(400).json({ error: 'Division by zero' });
            }
            result = n1 / n2;
            break;
        default:
            return res.status(400).json({ error: 'Invalid operation' });
    }

    res.json({ result });
});

app.listen(port, () => {
    console.log(`Calculator backend listening on port ${port}`);
});

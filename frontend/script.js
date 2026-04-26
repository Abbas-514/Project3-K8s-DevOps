async function calculate(operation) {
    const num1 = document.getElementById('num1').value;
    const num2 = document.getElementById('num2').value;
    const resultSpan = document.getElementById('result');
    const errorP = document.getElementById('error');

    resultSpan.textContent = '-';
    errorP.textContent = '';

    if (!num1 || !num2) {
        errorP.textContent = 'Please enter both numbers.';
        return;
    }

    try {
        const response = await fetch('/api/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ num1, num2, operation })
        });

        const data = await response.json();

        if (response.ok) {
            resultSpan.textContent = data.result;
        } else {
            errorP.textContent = data.error || 'An error occurred';
        }
    } catch (error) {
        console.error('Error:', error);
        errorP.textContent = 'Failed to connect to the server.';
    }
}

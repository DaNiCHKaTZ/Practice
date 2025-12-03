```javascript
//Механизм Event Loop №0

const fs = require('fs');

console.log('START'); // 1 Синхронные операции выполняются первыми 

setTimeout(() => {
  console.log('setTimeout 1'); // 4 Первая стадия event loop: timers, timer был зарегистрирован раньше, поэтому сработает раньше setTimeout 2

  setTimeout(() => {
    console.log('in setTimeout1'); // 8 (с файлом) / 10 (без файла) Будет выполнен в следующей стадии timers следующей итерации
  }, 0);

  setImmediate(() => {
    console.log('in setImmediate'); // 7 (с файлом) / 8 (без файла) Фаза check первой итерации
  });
}, 0);

setImmediate(() => console.log('setImmidiate')); // 6 (с файлом) / 7 (без файла) Фаза check первой итерации, после timers. Без файла может быть после readFile Next Tick 

process.nextTick(() => console.log('Next Tick')); // 3 Микротаска nextTick выполняется сразу после текущего стека, раньше любых фаз event loop

setTimeout(() => console.log('setTimeout 2'), 0); // 5 Тоже фаза timers первой итерации, pарегистрирован после setTimeout 1, поэтому идёт вторым среди таймеров 0ms

fs.readFile('info.txt', (err) => {
  // С файлом: колбэк приходит на следующей итерации после первой фазы check
  // Без файла: ошибка I/O завершается быстрее, колбэк приходит уже на первой итерации после timers
  setTimeout(() => console.log('readFile setTimeout'), 0); // 11 (с файлом и без) - таймер на следующей фазе timers после всех setImmediate
  setImmediate(() => console.log('readFile setImmediate')); // 10 (с файлом) / 9 (без файла) - фаза check после I/O колбэка
  process.nextTick(() => console.log('readFile Next Tick')); // 9 (с файлом) / 6 (без файла) - микротаска выполнится сразу после I/O колбэка, до check
});

console.log('END'); // 2 Синхронные операции выполняются первыми 

//Механизм Event Loop №1
console.log('A: sync start'); // 1 Синхронные операции выполняются первыми
setTimeout(() => {
  console.log('E: setTimeout 0'); // 6 Первая стадия event loop(timers), timers исполняются после выполненя всех задач из очереди микрозадач
}, 0);

Promise.resolve().then(() => {
  console.log('C: promise.then'); // 4 Микрозадача promise выполняется до любых фаз event loop
});

queueMicrotask(() => {
  console.log('D: queueMicrotask'); // 5 Та же очередь микрозадач, что и promise, попадает в очередь позже
});

process.nextTick(() => {
  console.log('B: nextTick'); // 3 Очередь nextTick приоритетнее микрозадач Promise/queueMicrotask 
});

console.log('F: sync end'); // 2 Синхронные операции выполняются первыми

//Механизм Event Loop №2
let count = 0;

function tickStorm(limit = 5) {
  if (count >= limit) return;
  process.nextTick(() => {
    console.log(`A: nextTick #${++count}`);
    tickStorm(limit);
  });
}

setTimeout(() => {
  console.log('B: setTimeout 0 (should not be starved)'); //5 Первая стадия even loop(timers), event loop начинает работу после выполнения всех задач из очереди микротасок
  setTimeout(() => {
    console.log('F: Set in set'); // 6 Вложенный setTimeout выполнится на следующей фазе timers, следующей итерации event loop 
    Promise.resolve().then(() => {
      console.log('G: promise in set'); // 7 Микрозадача Promise выполнится сразу после завершения колбэка setTimeout, до следующей фазы event loop
    }); 
  }, 0);  
}, 0); 

Promise.resolve().then(() => {
  console.log('C: promise.then (microtask)');
}); //4 Является микротаской имеет меньший приоритет чем nextTick, выполняется до event loop

console.log('D: sync start'); //1 Синхронные операции выполняются первыми 
tickStorm(5); //3 Пять вызовов функции nextTick, nextTick имеет больший приоритет чем promise, выполняется до event loop
console.log('E: sync end'); //2 Синхронные операции выполняются первыми 




//Задание 1  
//index.js 
console.log('Hello, Node.js!');
console.log('Я работаю на сервере!');
console.log('Текущее время:', new Date());
console.log('Версия Node.js:', process.version);
console.log('Платформа:', process.platform);

//Задание 2
//math.js
export function add (a, b) {
    return a + b;
}

export function subtract(a, b) {
    return a - b;
}

export function multiply (a, b) {
    return a * b;
}

export function divide (a, b) {
    return a / b;
}



//calculator.js
import { add, subtract, multiply, divide } from './math.js'
console.log (`2 + 3 = ${add(2, 3)}`);
console.log (`10 - 4 = ${subtract(10, 4)}`);
console.log (`5 * 6 = ${multiply(5, 6)}`);


//Задание 3 file.js
const fs = require('fs');

const content = 
`Привет из Node.js!
Время создания: ${new Date().toISOString()}
Версия Node.js: ${process.version}
`;

fs.writeFileSync('info.txt', content);
console.log("Файл info.txt создан");

const data = fs.readFileSync('info.txt', 'utf8');
console.log("Содержимое файла:");
console.log(data);

const additionalInfo = "\n\nДополнительная информация:";
fs.appendFileSync('info.txt', additionalInfo);
console.log("Информация добавлена в файл");

const updatedData = fs.readFileSync('info.txt', 'utf8');
console.log("Обновленное содержимое файла:");
console.log(updatedData);

const reversed = updatedData.split('').reverse().join(''); 
console.log("\n\nСодержимое файла задом наперёд:");
console.log(reversed);

//ЗАДАНИЕ 4
const evenSymbol = updatedData.split('').filter((_, index) => index % 2 === 0).join('');
console.log("\n\nСодержимое файла только четных символов:");
console.log(evenSymbol);
```
```javascript
// Царенко Даниил Дмитриевич
//1

// Promise.resolve возвращает промис, который сразу выполнен успешно
// Promise.reject возвращает промис, который сразу отклонен
const promises = [
  Promise.resolve('Успех 1'),  
  Promise.reject('Ошибка'), 
  Promise.resolve('Успех 2')
];

// Promise.all - ждёт выполнения всех промисов
// Если хотя бы один отклонён, весь Promise.all отклоняется
// Вернёт ошибку, так как второй промис отклонён
Promise.all(promises)
  .then(results => console.log('all:', results))
  .catch(error => console.log('all ошибка:', error)); 

// Promise.allSettled - ждёт выполнения всех промисов
// Возвращает массив результатов для каждого промиса с информацией о статусе (fulfilled или rejected)
// Обрабатывает все промисы даже с ошибками
Promise.allSettled(promises)
  .then(results => console.log('allSettled:', results));

//2

Promise.resolve("resolve")  // Promise.resolve создаёт сразу выполненный промис со значением "resolve" и состоянием fulfilled
 .then(v => { // Получаем значение "resolve"
   console.log(1, v);  // 1, resolve
   return "Tnen1"; // Возвращаем строку "Tnen1" она станет значение мследующего .then
 })
 .then(v => {
   console.log(2, v);  // 2, Then1
   return new Promise(res => { // Создаём новый промис, который будет выполнен асинхронно
     console.log(3, "start");  // 3, start 
     setTimeout(() => res("Next"), 0); // Выполнится в timers 
   });
 })
  //Ждём выполнения промиса из setTimeout
  //.then() выполнится после того, как setTimeout вызовет res("Next")
 .then(v => {
   console.log(4, v);  // 4 Next
   throw new Error("Boom"); // Выбрасываем ошибку с message "Boom", переходим в состояние reject, переходим в блок .catch
 })
 .catch(e => {
   console.log(5, e.message);  //5 Boom
   return "R"; // Возвращаем строку "R", возвращаем promise с состоянием fulfilled
 })
  // блок finally() выполняется независимо от успеха или ошибки
  // Выполнится после .catch(), до следующего .then()
 .finally(() => {
   console.log(6, "finally-1"); // 6 finally
 })
 // Блок finally не получает и не может изменить значение
 // Получаем значение из блока catch
 .then(v => {
   console.log(7, v);  // 7, R 
   return Promise.reject("Fail"); // Возвращаем promise с состоянием reject переходим в блок catch
 })
 .catch(e => {
   console.log(8, e);  // 8 Fail  не возвращаем значение - следующий блок получит undefined
 })
 // блок finally() выполняется независимо от успеха или ошибки
 .finally(() => console.log(9, "finally-2"));  // 9 Finally

//3 

// Асинхронная функция a1
async function a1() {
  // Синхронный код внутри async функции выполняется сразу при вызове
  console.log('1'); //2
  
  try {
    // Вызываем a2() - её синхронный код выполнится сразу
    // await приостанавливает выполнение функции a1 до завершения a2()
    const r = await a2(); 
    
    // Получаем результат 'ok' из a2()
    // Выполнится после всех микрозадач, которые были добавлены до этого
    console.log('2', r); // 7
  }
   // Так как в функции a2(), Promise.resolve() создаёт сразу выполненный промис, то в блок catch мы не попадаем
  catch (e) { 
    console.log('3', e.message); 
  }
}

// Асинхронная функция a2
async function a2() {
  // Синхронный код выполняется сразу при вызове
  console.log('4'); //3
  
  //await ждёт выполнения промиса
  // Promise.resolve() создаёт сразу выполненный промис
  // .then() добавляет микрозадачу в очередь, который выполнится после синхронного кода
  await Promise.resolve()
    .then(() => console.log('5')); // 5 
  
  // Возвращаем значение, которое получит a1()
  return 'ok';
}

// setTimeout добавляет задачу в очередь timers
// Выполнится после всех микрозадач 
setTimeout(() => console.log('6'), 0); // 9
console.log('7'); // 1 Синхронный код выполнится сразу 

// Вызываем async функцию a1, её синхронный код выполнится сразу, асинхронный код(await и promise) будут выполнены как микрозадачи
a1()
  .then(() => console.log('8')); // 8 Выполнитя после выполнения функции a1() (можем вызывать метод then, так как async возвращает promise)

//  Создаём промис и добавляем .then() в очередь микрозадач, попадает в очередь позже чем promise из функции a2()
Promise.resolve()
  .then(() => console.log('9')); // 6

// Шаг 4: Синхронный код выполняется сразу
console.log('10'); //4 

// Практическое задание
const fs = require("fs");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function parseArgs() {
  const args = process.argv.slice(2);
  const result = {};
  
  for (let i = 0; i < args.length; i++) {
    if (args[i].startsWith('--')) {
      const key = args[i].substring(2);
      const value = args[i + 1] && !args[i + 1].startsWith('--') ? args[i + 1] : undefined;
      result[key] = value;
      if (value) i++; 
    }
  }
  
  return result;
}

function generateId() {
  return Date.now().toString();
}

function loadUsers() {
  try {
    const data = fs.readFileSync("users.json", "utf-8");
    return JSON.parse(data);
  } catch (err) {
    if (err.code === "ENOENT") {
      console.log("Файл users.json не найден. Инициализирован пустой список.");
      let users = [];
      saveUsers(users);
      return users;
    } else if (err instanceof SyntaxError) {
      throw new Error(`Невалидный JSON. Ошибка: ${err.message}`);
    } else {
      throw new Error(`Ошибка при чтении файла: ${err.message}`);
    }
  }
}


function saveUsers(users) {
  fs.writeFileSync('users.json', JSON.stringify(users, null, 2), 'utf-8');
}

function formattedUsersShow(users) {
  if (users.length === 0) {
    return '[]';
  }
  return JSON.stringify(users, null, 2);
}

function addUser(name, email, id) {
  if (!name) {
    console.log("Поле 'name' является обязательным.");
    return false;
  }
  
  let users;
  try {
    users = loadUsers();
  } catch (err) {
    console.log(err.message);
    return false;
  }
  
  if (!id) {
    id = generateId();
  }

  if (users.some(user => user.id === id)) {
    console.log(`Пользователь с ID '${id}' уже существует.`);
    return false;
  }

  if (email && users.some(user => user.email === email)) {
    console.log(`Пользователь с email '${email}' уже существует.`);
    return false;
  }

  const newUser = {
    id: id,
    name: name,
    createdAt: new Date().toISOString()
  };
  
  if (email) {
    newUser.email = email;
  }
  
  users.push(newUser);
  saveUsers(users);
  
  console.log("Пользователь успешно добавлен:", newUser);
  return true;
}

function questionRestore(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

async function restoreFile() {
  const answer = await questionRestore("Восстановить файл? [y/n]: ");
  rl.close();
  
  if (answer.toLowerCase() === 'y') {
    let users = [];
    saveUsers(users);
    console.log("Файл восстановлен. Список пользователей:", users);
  } else {
    console.log("Восстановление отменено.");
  }
}


const args = parseArgs();

if (args.name || args.email || args.id) {
    try {
        const users = loadUsers();
        console.log('--- BEFORE ---');
        console.log(formattedUsersShow(users));
        addUser(args.name, args.email, args.id);
        console.log('--- AFTER ---');
        const updatedUsers = loadUsers();
        console.log(formattedUsersShow(updatedUsers));
        rl.close();
    }
    catch (err){
        if (err.message.includes("Невалидный JSON")) {
            console.log(err.message);
            restoreFile();
        } else {
            console.log(err.message);
            rl.close();
        }
    }
} else {
  try {
    const users = loadUsers();
    console.log(formattedUsersShow(users));
    rl.close();
  } catch (err) {
    if (err.message.includes("Невалидный JSON")) {
      console.log(err.message);
      restoreFile();
    } else {
      console.log(err.message);
      rl.close();
    }
  }
}



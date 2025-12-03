# Practice

## Домашнее задание - Последовательность команд Git

Этот файл содержит последовательность команд Git, которые использовались для выполнения домашнего задания.

### Клонирование репозитория

```bash
git clone https://github.com/DaNiCHKaTZ/Practice.git
cd Practice
```

### Домашнее задание 1 (homework1)

```bash
git checkout -b homework1
git add home_task.sql
git commit -m "Added answer for first homework"
git push origin homework1
```

**Примечание:** При первой попытке `git push` возникла ошибка о том, что ветка не имеет upstream. Была использована команда `git push origin homework1` для установки upstream.

### Домашнее задание 2 (homework2)

```bash
git checkout -b homework2
git add second_homework/
git commit -m "Added answer for second homework"
git push origin homework2
```

**Добавленные файлы:**
- `second_homework/task1/diagram.png`
- `second_homework/task1/init.sql`
- `second_homework/task2/query.sql`

### Домашнее задание 3 (homework3)

```bash
git checkout -b homework3
git add third_homework/
git commit -m "Added answer for third homework"
git push origin homework3
```

**Добавленные файлы:**
- `third_homework/Event Service API.postman_collection.json`
- `third_homework/problems.md`
- `third_homework/Царенко_Даниил_7.yaml`

### Первое задание Node.js (first_node)

```bash
git checkout -b first_node
git add home_task.sql
git add home_task.md
git commit -m "Added answer for first node homework"
git push origin first_node
```

**Примечание:** При первом коммите был добавлен только `home_task.sql`, но Git обнаружил неотслеживаемый файл `home_task.md`, который был добавлен отдельной командой `git add`.

### Второе задание Node.js (second_node)

```bash
git checkout -b second_node
git add second_node.md
git commit -m "Added answer for second node homework"
git push origin second_node
```

### Третье задание Node.js (third_node)

```bash
git checkout -b third_node
git add server_task.md
git commit -m "Added answer for third node homework"
git push origin third_node
```

## Общие примечания

- При добавлении файлов Git предупреждал о замене LF на CRLF (это нормально для Windows)
- Для первой ветки `homework1` потребовалось использовать `git push origin homework1` для установки upstream
- Для остальных веток команда `git push origin <branch_name>` работала автоматически
- Все ветки были успешно отправлены в удаленный репозиторий на GitHub

# VIVT_IT_4_Database

[![Python](https://img.shields.io/badge/-Python-464646?style=flat&logo=Python&logoColor=56C0C0&color=008080)](https://www.python.org/)
[![BeautifulSoup4](https://img.shields.io/badge/BeautifulSoup4-1.0.0-brightgreen)](https://www.crummy.com/software/BeautifulSoup/)
[![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-1.4.22-blue)](https://www.sqlalchemy.org/)


## Описание проекта

Создание, заполнение, обработка и вывод таблиц БД для дополнительной тренировки навыка.
С использованием простых процессов парсинга сайтов.

## Технологии

- SQLAchemy - для работы с базой данных
- SQLite - бд по умолчанию
- bs4 - парсинг данных

## Установка

1. Клонируйте репозиторий:

```bash
git clone https://github.com/VitsVi/vivt_it_4_database
```
2. Создайте виртуальное окружение в папке проекта и запустите его:

```bash
python -m venv venv
source venv/Scripts/activate
```

3. Установите файл зависимостей в виртуальном окружении:

```bash
pip install -r requirements.txt
```

3. Запустите процесс создания базы данных(сотрет текущую базу в проекте):

```bash
python colledge_db.py
```

4. (Опционально) Выдаёт заготовленные параметры поиска и записывает файлы в папку results проекта:

(формат файлов .csv)
```bash
python get_info_from_db.py
```

### Автор:  
_VitsVi_<br>
**email**: _Vits.Vi08@yandex.ru_<br>
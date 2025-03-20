"""Дополнительные функции для проверки запросов."""
import logging
from datetime import datetime
from random import randint


def find_tag(soup, tag, attrs=None):
    """Перехват ошибки поиска тегов."""
    searched_tag = soup.find(tag, attrs=(attrs or {}))
    if searched_tag is None:
        error_msg = f'Не найден тег {tag} {attrs}'
        logging.error(error_msg, stack_info=True)
        raise Exception(error_msg)
    return searched_tag

def generate_random_date(start_year, end_year):
    if start_year > end_year:
        raise Exception("Некорректный диапазон времени.")

    year = randint(start_year, end_year)
    month = randint(1, 12)
    day = randint(1, 28)
    try:
        return datetime(year, month, day).date()
    except ValueError:
        return generate_random_date(start_year, end_year)
    

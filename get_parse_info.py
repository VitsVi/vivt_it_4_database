from utils import find_tag
import requests
from constants import TEACHERS_URL, STREETS_NAME_URL
from bs4 import BeautifulSoup

def get_teachers_list():
    response = requests.get(TEACHERS_URL)
    soup = BeautifulSoup(response.text, features='lxml')
    table_tag = find_tag(soup, 'table')
    tr_tag = table_tag.find_all('tr', attrs={'itemprop':'teachingStaff'})
    teachers = []
    for tr in tr_tag:
        td_tag = find_tag(tr, 'td', attrs={'itemprop':'fio'})
        teachers.append(td_tag.get_text(strip=True, separator=''))
    return teachers


def get_students_list():
    students = []
    with open('students.txt','r', encoding='utf-8') as file:
        for line in file:
            students.append(line.rstrip())
    return students

def get_streets_name():
    response = requests.get(STREETS_NAME_URL)
    soup = BeautifulSoup(response.text, features='lxml')
    div_tag = find_tag(soup, 'ul', attrs={"class":"streets-list"})
    ul_tags = div_tag.find_all('li')
    
    streets = []
    for ul in ul_tags:
        streets.append(ul.get_text(strip=True, separator=''))
    return streets

get_streets_name()

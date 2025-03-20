
import os

from sqlalchemy import create_engine
from sqlalchemy.orm import Session

from db_tables import (Assessment, Base, Discipline, Speciality, Student,
                       Teacher)


#var7
def first_task(session):
    students = session.query(Student).all()
    average_assessment = {}
    for student in students:
        average = 0
        assessments = session.query(
            Assessment
        ).filter_by(student_id=student.id)
        count = 0
        for asmnt in assessments:
            count += 1
            average += asmnt.assessment
        if count > 0:
            average /= count
        if average != 0:
            average_assessment[
                f"{student.name} {student.surname}"
            ] = round(average, 2)
        else:
            average_assessment[
                f"{student.name} {student.surname}"
            ] = 'не было экзамена'

            
    
    with open(
        'results/average_assesssment.csv',
        'w',
        encoding='utf-8-sig'
    ) as file:
        file.write("Средние оценки учеников по экзаменам:\n")
        for asmnt, student in zip(
            average_assessment.values(), average_assessment.keys()
        ):
            file.write(f'{student} - {asmnt}\n')


def second_task(session):
    assessmnets = session.query(Assessment).all()
    teachers = session.query(Teacher).all()
    teachers_count = {}
    for teacher in teachers:
        teachers_count[f'{teacher.name} {teacher.surname}'] = 0
    
    for asmnt in assessmnets:
        teacher = session.query(
            Teacher
        ).filter_by(id=asmnt.teacher_id).first()
        teachers_count[f'{teacher.name} {teacher.surname}'] += 1
    
    with open(
        'results/teachers_asmnt_count.csv',
        'w',
        encoding='utf-8-sig'
    ) as file:
        file.write("Количество оценок среди преподавателей:\n")
        for asmnt, teacher in zip(
            teachers_count.values(), teachers_count.keys()
        ):
            file.write(f'{teacher} - {asmnt}\n')


def third_task(session):
    assessmnets = session.query(Assessment).all()
    students = ['Получили 5 по физике:']
    for asmnt in assessmnets:
        discipline = session.query(
            Discipline
        ).filter_by(id=asmnt.discipline_id).first()
        if discipline.name == 'Физика' and asmnt.assessment == 5:
            student = session.query(
                Student
            ).filter_by(id=asmnt.student_id).first()
            students.append(f'{student.name} {student.surname}')

    with open(
        'results/student_physics_5.csv',
        'w',
        encoding='utf-8-sig'
    ) as file:
        for student in students:
            file.write(f'{student}\n')

def fourth_task(session):
    teachers = session.query(Teacher).limit(3).all()
    with open(
        'results/first_3_teachers.csv',
        'w',
        encoding='utf-8-sig'
    ) as file:
        file.write("Первые 3 записи учителей\n")
        for teacher in teachers:
            file.write(
                f"{teacher.surname} {teacher.name} {teacher.second_name}\n"
            )

if __name__ == "__main__":
    engine = create_engine('sqlite:///colledge.db', echo=True)
    Base.metadata.create_all(engine)
    session = Session(engine)
    results_path = './results'
    os.mkdir(results_path)
    first_task(session)
    second_task(session)
    third_task(session)
    fourth_task(session)
from random import randint

from sqlalchemy import create_engine, func
from sqlalchemy.orm import Session

from constants import DISCIPLINE, GROUP, SPECIALITY
from db_tables import (Assessment, Base, Discipline, Speciality, Student,
                       Teacher)
from get_parse_info import (get_streets_name, get_students_list,
                            get_teachers_list)
from utils import generate_random_date


def main(session):
    #discipline
    tables = []
    for discipl in DISCIPLINE:
        tables.append(
            Discipline(name=discipl)
        )

    #speciality
    for spec in SPECIALITY:
        tables.append(
            Speciality(
                name=spec,
                training_period=randint(3,5)
            )
        )

    #teachers
    for teacher in get_teachers_list():
        teacher = teacher.split(' ')
        surname = teacher[0]
        if teacher[1]:
            name = teacher[1]
            second_name = teacher[2]
        else:
            name = teacher[2]
            second_name = '...'
        work_experience = randint(2,15)
        tables.append(
            Teacher(
                name=name,
                surname=surname,
                second_name=second_name,
                work_experience=work_experience,
            )
        )
    session.add_all(tables)
    tables = []
    #students
    for student, street in zip(get_students_list(), get_streets_name()):
        if student is None:
            break

        student = student.split(' ')
        surname = student[0]
        name = student[1]
        second_name = student[2]
        date_of_birth = generate_random_date(2000, 2007)
        city = 'Воронеж'
        if street is None:
            street = '...'
        else:
            street = street
        house_number = randint(1,150)
        appartment_number = randint(1,150)
        group = GROUP[randint(0, len(GROUP) - 1)]
        speciality_id = session.query(
            Speciality
        ).order_by(func.random()).first().id
        session.add(
            Student(
                name=name,
                surname=surname,
                second_name=second_name,
                date_of_birth=date_of_birth,
                city=city,
                street=street,
                house_number=house_number,
                appartment_number=appartment_number,
                group=group,
                speciality_id=speciality_id
            )
        )

    #assessment
    for i in range(100):
        student_id = session.query(
            Student
        ).order_by(func.random()).first().id
        discipline_id = session.query(
            Discipline
        ).order_by(func.random()).first().id
        teacher_id = session.query(
            Teacher
        ).order_by(func.random()).first().id
        exam_date = generate_random_date(2022, 2024)
        assessment = randint(2,5)
        session.add(
            Assessment(
                student_id=student_id,
                discipline_id=discipline_id,
                teacher_id=teacher_id,
                exam_date=exam_date,
                assessment=assessment,
            )
        )
    session.commit()



if __name__ == "__main__":
    engine = create_engine('sqlite:///colledge.db', echo=True)
    Base.metadata.create_all(engine)
    session = Session(engine)
    main(session)
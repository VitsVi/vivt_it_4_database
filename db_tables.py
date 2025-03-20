from sqlalchemy import Column, Date, ForeignKey, Integer, String
from sqlalchemy.orm import declarative_base, declared_attr


class PreBase:

    @declared_attr
    def __tablename__(cls):
        return cls.__name__.lower()

    id = Column(Integer, primary_key=True)


Base = declarative_base(cls=PreBase)


class Name():
    surname = Column(String(50))
    name = Column(String(50))
    second_name = Column(String(50))


class Student(Name, Base):
    date_of_birth = Column(Date)
    city = Column(String(30))
    street = Column(String(30))
    house_number = Column(String(10))
    appartment_number = Column(Integer)
    group = Column(String(10))
    speciality_id = Column(
        Integer, ForeignKey('speciality.id'), nullable=False
    )


class Speciality(Base):
    name = Column(String(50))
    training_period = Column(Integer)
    

class Discipline(Base):
    name = Column(String(50))


class Teacher(Name, Base):
    work_experience = Column(Integer)


class Assessment(Base):
    student_id = Column(
        Integer, ForeignKey('student.id'), nullable=False
    )
    discipline_id = Column(
        Integer, ForeignKey('discipline.id'), nullable=False
    )
    teacher_id = Column(
        Integer, ForeignKey('teacher.id'), nullable=False
    ) 
    exam_date = Column(Date)
    assessment = Column(Integer)
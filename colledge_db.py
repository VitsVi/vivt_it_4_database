from sqlalchemy import create_engine, Table, Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import declarative_base, declared_attr, relationship, Session


#students speciality discipline teacher assessment 

class PreBase:

    @declared_attr
    def __tablename__(cls):
        return cls.__name__.lower()

    id = Column(Integer, primary_key=True)
    

class Name():
    name = Column(String(50))
    surname = Column(String(50))
    second_name = Column(String(50))


Base = declarative_base(cls=PreBase)


class Student(Name, Base):
    date_of_birth = Column(DateTime)
    city = Column(String(30))
    street = Column(String(30))
    house_number = Column(String(10))
    appartment_number = Column(Integer)
    group = Column(String(10))
    speciality_id = Column(Integer, ForeignKey('speciality.id'))
    speciality = relationship('Speciality', uselist=False)


class Speciality(Base):
    name = Column(String(50))
    training_period = Column(Integer)
    

class Discipline(Base):
    name = Column(String(50))


class Teacher(Name, Base):
    work_experience = Column(Integer)


class Assessment(Base):
    #student-many discipline-many teacher-many
    student = relationship('Student', uselist=False)
    discipline = relationship('Discipline', uselist=False)
    teacher = relationship('Teacher', uselist=False)
    exam_date = Column(DateTime)
    assessment = Column(Integer)
    
    
def main():
    engine = create_engine('sqlite:///sqlite.db', echo=True)
    with Session(engine) as session:
        session.add

if __name__ == "__main__":
    main()
--CREATE DATABASE board;
--SHOW DATABASES;


--USE

--문자 인코딩 변경
 SHOW VARIABLES LIKE 'character_set_server';
--테이블 목록조회

--테이블 생성 DDL

--SQL문은 대문자 관례이고, 시스템에서 대소문자를 구문하지는 않음
--테이블명.컬럼명 등은 소무자가 관례이고, 대소문자가 차이가 있음
--테이블 생성
CREATE TABLE author(id int primary key,name varchar(255),email varchar(255),passward varchar(255));
-- 테이블 컬럼정보 조회
describe author;

--테이블 데이터 전체 조회
select * from author;

--테이블 생성명령문 조회(실무에서 잘 사용안하지만 써먹을때까있음)
SHOW CREATE TABLE author;

--posts 테이블 신규 생성 (id,title contents author_id)
CREATE TABLE posts
(   id int primary key, 
    title varchar(255),
    contents varchar(255),
    author_id int);

CREATE TABLE posts (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    contents VARCHAR(255),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES author(id)
);

-- posts 테이블 신규 생성 (id, title, contents, author_id)
CREATE TABLE posts (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    contents VARCHAR(255),
    author_id INT
);

-- 외래키 포함 posts 테이블 생성
CREATE TABLE posts (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    contents VARCHAR(255),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES author(id)
);

-- 테이블 컬럼명 변경 (예: contents → body 로 변경 예시)
ALTER TABLE posts
CHANGE COLUMN contents body VARCHAR(255);

-- 테이블 컬럼 제약조건 추가 (예: title을 NOT NULL로 변경)
ALTER TABLE posts
MODIFY COLUMN title VARCHAR(255) NOT NULL;

-- 테이블 컬럼의 타입과 제약조건 변경 (예: author_id를 BIGINT로 변경하고 NOT NULL)
ALTER TABLE posts
MODIFY COLUMN author_id BIGINT NOT NULL;

-- 실습 1. AUTHOR 테이블에 주소 컬럼을 추가 (길이 255, NOT NULL)
ALTER TABLE author
ADD COLUMN address VARCHAR(255) NOT NULL;

-- 실습 2. POSTS 테이블에서
-- (1) title 컬럼을 NOT NULL로 변경
-- (2) contents 컬럼명을 contents → contents 로 오타 수정
ALTER TABLE posts
MODIFY COLUMN title VARCHAR(255) NOT NULL;

ALTER TABLE posts
CHANGE COLUMN contens contents VARCHAR(255);
-- ↑ 만약 원래 컬럼명이 contents라면 위 쿼리는 생략해도 됩니다.

--삽입
--업데이트
--삭제

--트렌젝션 실습 포스트에 글쓰기 
post에 글쓰기 insert 

-------------------------------------------------------------------------------------

--데이터 베이스는 멀티스레드 처리
동시 작업을 처리 해주되 기준 -> 격리 수준, 격리 레벨
리피터블 리드 
로스트 업데이트가 발생 (읽기 작업부터 오데이터를 읽게 됨)-> 보통의 대부분 동시성 이슈를 말한다
-> 해결책 레디스 사용(보통)

--------------------------------------------------------------------------------------
해결책 DB에서 베타락
읽지도 못하게 만들어 버림
셀렉 포 업데이트

시리즈 라이어블 -> 격리 수준이 가장 높음 멀티스레드 X 한건 한건 처리 
효율성이 안좋다 한건한건 처리 
좋은 해결책은 아니다 

팸턴 데이터 -> 유령데이터 -> 시간차 수정에 의한 없던 데이터가 생성 (생성 셀렉 후 취소 )

----------------------------------------------------------------------------------------



예매 사이트 
인셀트 (주문) 업데이트(재고)



낙관적 락
만하면 동시성 안생길꺼야
버전 정도를 활용하여 업데이트시 정합성을 활용한다
버전 컬럼 


후자의 업데이트가 실패가 되도록 만들어 버린다

싱크로라이즈드 스프링에 적용해서 싱글스레드화 시켜도 스프링에서 DB에 도착하는 시간을 통제 예측 할 수 없음 
이방법은 DB 자체 락이 아니므로 베타락이라 공유락을 쓰지 싱크로라이즈드를 사용하지 않는다

레드스사용 (프로그램)     
싱글 스레드 기반 키 밸류 시스템에서
한번에 하나밖에 처리하지 못함

싱글스레드의 단점 속도가 느리다는게 있지만 레드스는 
인메모리 
메모리 위에서 동작 해서 성능이 빠르다 

DRB 에 그외 데이터 관리 (정기적으로 저장하여)

메모리 기반 단점 : 휘발성 -> 정기적으로 스토리지에 저장은 하지만 휘발성이 있다

RDB ->스토리지 사용하다 메모리 가끔 섞어 사용해서 성능을 높임



**메서드 

비관적 락
이건 동시성 문제가 생길것같아 
공유락
베타락


성능이 떨어진다(사용자 입장에서 속도가 떨어진다)




조인 

이너 조인 
레프트조인
포스트인어조인
아더레트조인포스트
포스트레프트조인아더


a인너 조인 b  두테이블의 공통된 데이터로 교집합
             글쓴이가 있는 글을 조회
b인어 조인 a
  글쓴적이 있는 저자와 해당 글쓴이가 쓴 글 목록 조회

a f레프트 조인 b

b 레프트 조인 a



8. 조인.SQL

--케이스 1 
--글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
select a.* b.* from author a inner join post p on a.id=p.author_id;

--케이스2 
--글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on p.author_id = a.id;

--글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
SELECT p.*, a.email
FROM post p
INNER JOIN author a ON p.author_id = a.id;

--글쓴이가 있는글 글쓴이의 제목과 저자의 이메일을 출력하되 나이  30세 이상만


케이스 1= 케이스 2는 결과가 동일하다 순서만 바뀔뿐



--케이스3
--글쓴이는 모두 조히하되, 만약 쓴글이 있다면 글도 함께 조회
select * from author left join post a on p.author_id=a.id;
--케이스4
--글을 모두 죄하되, 글쓴이가 있다면 글쓴이도 함께 조회
select * from post p left join author a on p.author_id=a.id;

유니언 :두테이블의 셀렉트 결과를 횡으로 결합
유니언을 시킬때 컬럼으 개수와 컬럼의 타입이 같아야함

중복제거
SELECT name, email 
FROM author
UNION 
SELECT title, contents 
FROM posts;

중복 허용
SELECT name, email 
FROM author
UNION all
SELECT title, contents 
FROM posts;

--null값은 in조건절에서 자동으로 제외
--서브쿼리 : select문 안에 또다른 select문을 서브 쿼리함

SELECT DISTINCT author_id 
FROM post 
WHERE author_id IS NOT NULL;



SELECT author_id, total 
FROM (
    SELECT author_id, COUNT(*) AS total 
    FROM post 
    GROUP BY author_id
) AS sub;

where 절 안에 서브쿼리

한번이라도 글을쓴 작가의 아이디값 조회  중복제거



컬럼위치에 서브 쿼리는

프롬절 위치에 서브쿼리


그룹바이 칼럼명 특정 컬럼으로 데이터를 그룹화 하여 하난의 행 처럼 취급
세레트 아더아이디 프롬 포스트 그룹바이 아덜 아이


집계함수 
셀레트 카운트 (*) 프롬 작가
셀레트 합계(나이) 프롬 작가
셀레트 평균(나이) 프롬 작가
WHERE 절 안에 서브쿼리 (Subquery in WHERE clause)

한 번이라도 글을 쓴 작가의 ID만 중복 없이 조회하고 싶을 때

SELECT DISTINCT author_id 
FROM post 
WHERE author_id IS NOT NULL;

📌 SELECT 절에 서브쿼리 (Subquery in SELECT column)

작가별 글 개수를 함께 보여주고 싶을 때

SELECT name, 
       (SELECT COUNT(*) 
        FROM post 
        WHERE post.author_id = author.id) AS post_count 
FROM author;

📌 FROM 절에 서브쿼리 (Subquery in FROM clause)

서브쿼리 결과를 가상 테이블로 사용

SELECT author_id, total 
FROM (
    SELECT author_id, COUNT(*) AS total 
    FROM post 
    GROUP BY author_id
) AS sub;

📌 GROUP BY 특정 컬럼

특정 컬럼 기준으로 그룹화하여 하나의 행처럼 취급

SELECT author_id 
FROM post 
GROUP BY author_id;

📌 집계 함수 (Aggregate Functions)

글쓴이 수 구하기:

SELECT COUNT(*) FROM author;


나이 합계:

SELECT SUM(age) FROM author;


평균 나이:

SELECT AVG(age) FROM author;



동명 동물 수 찾기 -> 해빙
카테고리 별 도서 판매량 집계하기->조인까지
조건에 맞는 사용자와 촐 거래금액 조회하기 ->조인까지


select * from posts;


회원가입을 담당하였다.
main check out 및 pull
3.feat/member 브랜치 생성
4.commit id2개 정도 임의 생성
origin에서 생성
/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name FROM Facilities WHERE  membercost >0;

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(*) FROM Facilities WHERE  membercost =0;

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, NAME, membercost, monthlymaintenance FROM facilities 
WHERE membercost > 0 AND ( membercost < monthlymaintenance * 0.20);


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT * FROM Facilities WHERE facid IN (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT NAME,monthlymaintenance , case when monthlymaintenance > 100 then 'expensive' ELSE 'cheap' END AS  'cost' 
FROM Facilities 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT * FROM members WHERE memid IN ((select MIN(memid) FROM members),(select MAX(memid) FROM members));

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT concat(members.firstname , ' ',members.surname ,' : ', facilities.name ) AS members
FROM bookings ,members, facilities 
WHERE members.memid=bookings.memid AND facilities.facid = bookings.facid
GROUP BY members.firstname, members.surname ,facilities.name 
ORDER BY members.firstname, members.surname

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT concat(members.firstname ,' ' ,members.surname) AS name, 
case when members.firstname='GUEST' then facilities.guestcost*bookings.slots ELSE facilities.membercost*bookings.slots END AS  'cost' 
FROM bookings ,members, facilities 
WHERE members.memid=bookings.memid AND facilities.facid = bookings.facid
AND bookings.starttime like'2012-09-14%' 
 AND (facilities.membercost*bookings.slots >= 30 OR (facilities.guestcost*bookings.slots >= 30 AND members.firstname='GUEST'))
ORDER BY cost


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT * FROM (
SELECT concat(members.firstname ,' ' ,members.surname) AS NAME,
CASE WHEN Bookings.memid =0
	THEN Facilities.guestcost * Bookings.slots
	ELSE Facilities.membercost * Bookings.slots
	END AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND left(Bookings.starttime, 10) = '2012-09-14'
INNER JOIN Members ON Bookings.memid = Members.memid
)subq
WHERE subq.cost >=30
ORDER BY subq.cost;

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT subq.name , SUM(subq.cost) FROM (
SELECT facilities.name ,
 case when bookings.memid =0 then facilities.guestcost*bookings.slots ELSE facilities.membercost*bookings.slots END AS  'cost'
FROM  bookings,facilities
WHERE bookings.facid = facilities.facid
) subq 
GROUP BY subq.name;
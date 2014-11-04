byte x = 2;

active proctype A()
{
  do
	:: x = 3-x; progress: skip
  od 
}
active proctype B()
{
  do
	:: x = 3-x; progress: skip
  od 
}

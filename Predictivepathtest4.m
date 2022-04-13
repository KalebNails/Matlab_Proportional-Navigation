clc, clearvars, clear,

%This introduces the user to the function and also asks them if they want
%an excel file containing all the data
fprintf(['Welcome to a Proportional Navigation Simulation!\n' ...
    '    In this you will control one moving shape by using WASD in order to attempt to avoid the other shape.\n' ...
    'you can go off of the grid but the data will still be collected.\n \n' ...
    '    The GOAL of this program is to simulate proportional navigation or a simplified missle interception. \n' ...
    'You will control the DOT that appears on the right side of the screen and try to avoid the other dot. \n' ...
    'All of the relevent data can be exported to an excel spreadsheet in order to record\nwhat this program does throughout its runtime.' ...
    '\nThe program will automatically stop when the two shapes collide. '])
Willdataexport = input([' \n \n Would you like an excel spreadsheet of the data collected throughout this experiment (for example 1)? \n' ...
    '1. YES\n' ...
    '2. NO                        NOTE: It will IMEDIATELY start upon an answer to this prompt.\n']);

while isempty(Willdataexport) | Willdataexport ~= [1,2]
        Willdataexport = input('Invalid input. Try entering 1 for yes and 2 for no: ');
    end        
%Simulates loading to improve user experience
clc
%<SM:FOR>
for loading = 1:4    
    for periods = 1:5
        fprintf('.')
        pause(.2)
    end
    clc
end

%Figure spawns and window and these give the cordinates for the traingle
f= figure;
%Now we will define a global variable that will be used in order to collect
%user inputs
global Keypressed
Keypressed = 6;

%This sets the property of the figure up equal to f, then begins to get
%ready to listen to keystrokes
%<SM:PDF_CALL> %<SM:PDF_PARAM>
set(f,'WindowKeyPressFcn',@keyPressCallback);

%Thisgives a random y variable that is a whole number that will be used at
%the starting y position for the traingle shape
%<SM:RANDGEN>
roughstarty = rand(1,1)*(300+200)-200;
%<SM:RANDUSE>
TRstartingy = round(roughstarty);

%This adjusts the position of the traingle on each cord according to the
%last letting in adjust
adjustx = 200;
adjusty = TRstartingy;
pX = [0+adjustx -1+adjustx 1+adjustx]';
pY = [0+adjusty -1+adjusty -1+adjusty]';

%This will create the second square shape 
SQadjustx = -200;
SQadjusty = -300;
sqX = [3+SQadjustx 2+SQadjustx 2+SQadjustx 3+SQadjustx]';
sqY = [2+SQadjusty 2+SQadjusty 3+SQadjusty 3+SQadjusty]';

%this fills the space in between the vertices and set axis
plane = fill(pX, pY, 'red');
hold on
square = fill(sqX,sqY,'b');

%This sets the size of the graph, should be at min 300 because that is the
%max range the shapes can spawn in
ax = 400;
axis([-ax ax -ax ax])

%This gets the vertices of the plane and puts them in a matrix
cords = get(plane, 'Vertices')';
sqcords = get(square, 'Vertices')';
count = 0;

%calculate difference between x and y component of a cord on each shape
movx =sqcords(1,1) - cords(1,1);
movy = sqcords(2,1) - cords(2,1);

%This give initial velocity to the square
SquareXveloc = 100;
SquareYveloc = -300;

%here we set the initial variables for user control
TRIXveloc = (-.1);
TRIYveloc = (-.1);
Scount = 0.3;
Wcount = 0.2;
Acount = 0.4;
Dcount = 0.3;

%This creates an empty matrix that will be used to tally total distance
%between projectiles. 2000 is an arbitrary estimate of how many iteration
%through the while loop it will take to collide, the reason we need the
%zeros is it improves runtime instead of constantly increasing the size of
%a matrix
TotalDistanceX = zeros(2000,1);
TotalDistanceY = zeros(2000,1);
TotalDistance = zeros(2000,1);
TotalAngle = zeros(2000,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This is used to create a variable that records the location of the last
%entered value
Lastenteredvalue = 1;

%This while either checks for the the TotalDistance to be full of nonzeros
%which only occurs at the start, or it checks that the last enetered value
%for TotalDistance is below a certain threshhold
%<SM:ROP> %<SM:BOP> %<SM:WHILE>
while TotalDistance(Lastenteredvalue) > .8 || nnz(TotalDistance) == 0 

    %<SM:PDF_RETURN> (since its global its technically not returned, but
    %this was my best guess at where it should be)
    Winput = strcmp(Keypressed,'w');
    Ainput = strcmp(Keypressed,'a');
    Sinput = strcmp(Keypressed,'s');
    %<SM:STRING>
    Dinput = strcmp(Keypressed,'d');

%This checks which input is detected and changes the direction of x and y for
%the triangle, the longer one input is held for the larger the turn is
%because if we imagine these shapes as objects, they are constantly
%acceralting in any direction you put them in.
%<SM:IF>
    if Winput == 1
     Wcount = .5+Wcount;

    elseif Ainput == 1
     Acount = .5+Acount;

    elseif Sinput == 1 
     Scount = .5+Scount;
      
    elseif Dinput == 1
     Dcount = .5+Dcount;

    end
    
    %This simulates momentum in order to keep the shape from turning on a
    %dime, and allows for the calculation of a net velocity
    TRIXveloc = (Dcount)-Acount;
    TRIYveloc = (-Scount)+Wcount; 

    %This calculates the magnitude of the traingle velocity in order to
    %calculate the unit vector of its direction. A unit vector matrix is
    %then made that represents the components of the unit vector using
    %repmat
    MagnitudeTRI = sqrt(TRIXveloc^2+TRIYveloc^2);
    map = repmat([TRIXveloc/MagnitudeTRI; TRIYveloc/MagnitudeTRI],1,3);

    %This represents the vector components of the square in distance that
    %will be added to each corner of the square
    %<SM:NEWFUN>
    sqmap = repmat([SquareXveloc; SquareYveloc],1,4);

    %Gives the angle between the squares current heading compared to the
    %horizon.
    sqhorizon = [1,0];
    sqheading = [SquareXveloc, SquareYveloc];
    MagnitudeSQ = sqrt(sqheading(1,1)^2+sqheading(1,2)^2);
    sqtheta = acosd(dot(sqhorizon,sqheading) /(MagnitudeSQ));

    %Find the angle bewteen the traingles velocity and the horizon
    theta = acosd(dot(sqhorizon,[TRIXveloc,TRIYveloc]) /(MagnitudeTRI));
   
    %This is what set speed and begins to calculate where the shapes will be
    %translated to.
   % What # is multiply map by is the percent speed the fleeing object will
   % travel in respect to the chasing object, 1 being the same speed

    vel = .6*map;
    FAKEsqvel = 1*sqmap;

    %We then adjust the traingles cords by its current cords plus its
    %velocity. It also estimates the future square position based on
    %current knowledge about its velocity
    cords = vel + cords;
    fakesqcords = FAKEsqvel + sqcords;

    %This will predict the future line of sight angle from to the horizon
    %for the square
    %<SM:REF>
    fakemovx =fakesqcords(1,1) - cords(1,1);
    fakemovy = fakesqcords(2,1) - cords(2,1);
    FutureMagoflooktosquare =  sqrt((fakemovx)^2+(fakemovy)^2);
    Adjusttheta = acosd(dot(sqhorizon,[fakemovx,fakemovy]) /(FutureMagoflooktosquare));

    %BELOW SHOWS HOW THE ANGLE THAT NEEDS TO EXIST IN ORDER TO PREDICTIVE
    %FIRE IS CALCULATED.
    DesiredAngle = 2*(Adjusttheta - theta) + sqtheta;

    %This is used to adjust for according to the desiredangle, this works
    %by either changing the X or Y component of the velocity depending on
    %which one is greater.
    %<SM:NEST>
    if abs(movx) < abs(movy)
        SquareYveloc = SquareXveloc*tand(DesiredAngle)-movy;

    elseif abs(movx) > abs(movy)
        SquareXveloc = SquareYveloc*tand(DesiredAngle)-movx;
    end

    %This finds the new unit vector the square actually need to be headed
    %in order to maintain a collision triangle, and then addjusts its
    %velocity accordingly
    newMagnitudeSQ = sqrt(SquareXveloc^2+SquareYveloc^2);
    SquareXveloc = SquareXveloc/newMagnitudeSQ;
    SquareYveloc = SquareYveloc/newMagnitudeSQ;

    sqmap = repmat([SquareXveloc; SquareYveloc],1,4);
    sqvel = 1*sqmap;
    sqcords = sqvel + sqcords;

    %This calculates the line of sight components in the future movement
    movx =sqcords(1,1) - cords(1,1);
    movy = sqcords(2,1) - cords(2,1);

    %This records the total distances through the particular loop and it
    %uses the fact that totaldistance is a large matrix of all zeros, so
    %its counting the number of zeros and adding one to it to indicate the
    %next zero under the last data point entered.
    TotalDistanceX(1+nnz(TotalDistanceX)) = movx;
    TotalDistanceY(1+nnz(TotalDistanceX)) = movy;
    TotalDistance(1+nnz(TotalDistanceX)) = sqrt(movy^2+movx^2);

    %pause is what make the graph slowly move
    pause(0.01)

    %creates a trail behind the dots, count determines how frequent, and
    %plot uses cords of the vertices of the shapes before they become full
    %shapes again.

    count = count + 1;
    if count >= 40
        %<SM:PLOT>
        plot(cords(1,1),cords(2,2),'r*','MarkerSize',2)
        plot(sqcords(1,1),sqcords(2,2),'b*','MarkerSize',2)
        count = 0;
    end

    %set the new cordinates of the shapes
    set(plane,'vertices',cords');
    set(square,'vertices',sqcords');

    %This sets up the finds the lastest entered variable by counting the
    %number of non zero values
    %<SM:SEARCH>
    Lastenteredvalue = find(TotalDistance,1,"last");
    TotalAngle(Lastenteredvalue) = DesiredAngle;
end

%This checks if the user wants to export the data to an excel spreadsheet,
%then finds the total distance between points and agrigates that into a
%matrix and pushes it out to an excel file
if Willdataexport == 1
   validDatapoints = find(TotalDistance ~=0);
   FinalCollectedData = [TotalDistanceX(validDatapoints-1,:),TotalDistanceY(validDatapoints,:),TotalDistance(validDatapoints,:),TotalAngle(validDatapoints,:)];
   %<SM:WRITE>
   xlswrite("Nailspathfinder.xlsx",FinalCollectedData);
   fprintf('Your file has been exported. \n')
else
    fprintf('have a nice day. \n')
end

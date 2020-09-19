function MATLABHANGMAN
%This function takes no inputs and returns no outputs - simply call the
%function, MATLABHANGMAN to begin. The user must select a category of word
%to choose from. Once this selction has been made it cannot be altered by
%selecting a different option from the popup menu. The user also selects
%how many lives they would like to have. Once this selction has been made
%it cannot be altered by selecting a different radiobutton. The user then
%must guess the letters in the generated word by inputting a single
%capitalized letter into the edit box and hitting enter. Selections not of
%this form will be assumed incorrect. The user has up to the number of
%lives selected to guess each of the letters in the chosen word. Doing so
%without running out of lives results in a win whereas running out of lives
%before guessing all the letters in the word results in a loss.

% set up the figure window
f=figure('Visible','On','Position',[500, 500, 700, 600]); %initiate figure window
set(f, 'Resize', 'off')
h_axes=axes('Units','normalized','Position',[.1 .1 .5 .75],'YTickLabel',[],'XTickLabel',[],'ytick',[],'xtick',[]);

%set up hang
x1=linspace(3.5,3.5,6); %vertical piece
y1=4:9;
hold on
plot(x1,y1,'Color',[.5,.2,.05],'LineWidth',3)

x2=2:5; %bottom of hang
y2=[4 4 4 4];
plot(x2,y2,'Color',[.5,.2,.05],'LineWidth',3)

x3=linspace(3.5,6,3); %top of hang
y3=[9 9 9];
plot(x3,y3,'Color',[.5,.2,.05],'LineWidth',3)

x4=linspace(6,6,3); %tick of hang
y4=[9 8.25 8.5];
plot(x4,y4,'Color',[.5,.2,.05],'LineWidth',3)

theta1 = 0:pi/50:2*pi; %head 
x5 = .5*cos(theta1) + 6;
y5 = .5*sin(theta1) + 7.75;
head=fill(x5,y5,'w','LineStyle','none'); %make invisible without deleting handle

x6=[6 6 6]; %body
y6=[5.5 6.75 7.25];
body=plot(x6,y6,'Color',[.9,.75,.6],'LineWidth',5);
set(body,'Color','w') %make invisible without deleting handle

x7=[6 5.3]; %left leg
y7=[5.6 4.5];
leftleg=plot(x7,y7,'Color',[.9,.75,.6],'LineWidth',5);
set(leftleg,'Color','w') %make invisible without deleting handle

x8=[6 6.7]; %right leg
y8=[5.6 4.5];
rightleg=plot(x8,y8,'Color',[.9,.75,.6],'LineWidth',5);
set(rightleg,'Color','w'); %make invisible without deleting handle

x9=[6 6.6]; %right arm
y9=[6.5 7];
rightarm=plot(x9,y9,'Color',[.9,.75,.6],'LineWidth',5);
set(rightarm,'Color','w') %make invisible without deleting handle

x10=[6 5.4]; %left arm
y10=[6.5 7];
leftarm=plot(x10,y10,'Color',[.9,.75,.6],'LineWidth',5);
set(leftarm,'Color','w') %make invisible without deleting handle

lefteye=plot(5.75,7.75,'xk','LineWidth',3); %left eye
set(lefteye,'Color','w') %make invisible without deleting handle

righteye=plot(6.25,7.75,'xk','LineWidth',3); %right eye
set(righteye,'Color','w') %make invisible without deleting handle

theta2=0:pi/25:pi; %mouth
x11=.2*cos(theta2)+6; 
y11=.05*sin(theta2)+7.4;
mouth=plot(x11,y11,'k','LineWidth',3);
set(mouth,'Color','w') %make invisible without deleting handle

axis([0 10 0 10]) %axes limits

%create editbox for user letter guess and associated text 
input_guess=annotation('textbox', [.12, .9, .29, .07], 'string', 'Enter a guess:','Color','blue',...
    'EdgeColor','none');
input_guess.FontSize=30;
letter_guess=uicontrol('Style','edit','Units','normalized','Position',[.42 .9 .05 .07],...
    'BackgroundColor','g','ForegroundColor','blue','Callback', @editbox_Callback);
letter_guess.FontSize=30;

%create popup menu for word categories and associated text 
popup_categories=uicontrol('Style','popupmenu','Units','normalized','Position',[.68 .65 .2 .1],...
    'String',{'US Presidents','Capital Cities of the World','Famous Scientists','NBA Teams','NFL Teams','Surprise Me!!!'},....
    'Callback',@popup_Callback);
select_category=annotation('textbox', [.68, .78, .2, .04],'string', 'Select a category:',...
    'Color','blue','EdgeColor','none');
select_category.FontSize=15;

%create 4 radio buttons in a group and associated text
bg = uibuttongroup('Units','normalized','Position',[.7 .4 .16 .2],'SelectionChangedFcn',@bselection_Callback);
select_lives=annotation('textbox', [.68, .6, .2, .04],'string', 'Select Number of Lives:',...
    'Color','blue','EdgeColor','none');
select_lives.FontSize=12;
six_lives=uicontrol(bg,'Style','radiobutton','String','6 Lives','Units','normalized','Position',[.25 .72 .75 .18]);
seven_lives=uicontrol(bg,'Style','radiobutton','String','7 Lives','Units','normalized','Position',[.25 .52 .75 .18]);
eight_lives=uicontrol(bg,'Style','radiobutton','String','8 Lives','Units','normalized','Position',[.25 .32 .75 .18]);
nine_lives=uicontrol(bg,'Style','radiobutton','String','9 Lives','Units','normalized','Position',[.25 .12 .75 .18]);

%text for number of guesses remaining and associated text
num_lives=6; %initialize variable, default radio button for number of lives is 6
number=uicontrol('Style','text','String',num2str(num_lives),'Units','normalized','Position',[.9 .91 .05 .045],...
    'BackgroundColor','r','ForegroundColor','white');
number.FontSize=16;
number_guesses=annotation('textbox', [.63, .85, .29, .1], 'string', 'Number of Guesses Remaining:','Color','red',...
    'EdgeColor','none');
number_guesses.FontSize=12;

%create/load the data
US_Presidents_data={'WASHINGTON', 'ADAMS', 'JEFFERSON','MADISON',...
    'MONROE', 'ADAMS', 'JACKSON', 'VANBUREN',...
    'HARRISON', 'TYLER', 'POLK', 'TAYLOR', 'FILLMORE',...
    'PIERCE', 'BUCHANAN', 'LINCOLN', 'JOHNSON', 'GRANT',...
    'HAYES', 'GARFIELD', 'ARTHUR', 'CLEVELAND',...
    'HARRISON', 'MCKINLEY', 'ROOSEVELT', 'TAFT'...
    'WILSON', 'HARDING','COOLIDGE', 'HOOVER','ROOSEVELT',...
    'TRUMAN', 'EISENHOWER', 'KENNEDY','JOHNSON', 'NIXON',...
    'FORD', 'CARTER', 'REAGAN', 'BUSH', 'CLINTON', 'BUSH',...
    'OBAMA', 'TRUMP'}; %data set for US Presidents

Capitals_data={'KABUL', 'VIENNA', 'BRUSSELS', 'SOFIA', 'OTTAWA', 'BEIJING',...
    'BOGOTA', 'HAVANA', 'PRAGUE', 'QUITO', 'CAIRO', 'HELSINKI', 'PARIS',...
    'BERLIN', 'ATHENS', 'BUDAPEST', 'JAKARTA', 'TEHRAN', 'BAGHDAD', 'DUBLIN',...
    'JERUSALEM', 'ROME', 'TOKYO', 'NAIROBI', 'AMSTERDAM', 'OSLO', 'LIMA',...
    'MANILA', 'MOSCOW', 'SEOUL', 'MADRID', 'BANGKOK', 'ANKARA', 'WASHINGTON', 'HANOI'}; %data set for capitals

Scientists_data={'EINSTEIN', 'CURIE', 'NEWTON', 'GALILEO', 'DARWIN', 'HAWKING',...
    'TESLA', 'PASTEUR', 'EDISON', 'COPERNICUS', 'FARADAY', 'BOHR', 'DAVINCI', 'KEPLER',...
    'MENDEL', 'PLANCK', 'FRANKLIN', 'WATSON', 'CRICK', 'HUBBLE', 'RUTHERFORD', 'FLEMING',...
    'MENDELEEV', 'HOOKE', 'PASCAL', 'HERTZ', 'VOLTA', 'THOMSON', 'SCHRODINGER', 'AMPERE'}; %data set for scientists

NBA_Teams_data={'HAWKS','CELTICS','NETS','HORNETS','BULLS',...
    'CAVALIERS', 'MAVERICKS', 'NUGGETS', 'PISTONS', 'WARRIORS',...
    'ROCKETS', 'PACERS', 'CLIPPERS', 'LAKERS', 'GRIZZLIES', 'HEAT',...
    'BUCKS', 'TIMBERWOLVES', 'PELICANS', 'KNICKS', 'THUNDER', 'MAGIC', 'SEVENTYSIXERS',...
    'SUNS', 'TRAILBLAZERS', 'KINGS', 'SPURS', 'RAPTORS', 'JAZZ', 'WIZARDS'}; %data set for NBA teams

NFL_Teams_data={'CARDINALS','FALCONS','RAVENS','BILLS','PANTHERS', 'BEARS',...
    'BENGALS', 'BROWNS', 'COWBOYS', 'BRONCOS', 'LIONS', 'PACKERS', 'TEXANS',...
    'COLTS', 'JAGUARS', 'CHIEFS','CHARGERS', 'RAMS', 'DOLPHINS', 'VIKINGS',...
    'PATRIOTS', 'SAINTS', 'GIANTS', 'JETS', 'RAIDERS', 'EAGLES', 'STEELERS',...
    'FORTYNINERS', 'SEEHAWKS', 'BUCCANEERS', 'TITANS', 'REDSKINS'}; %data set for NFL teams

Surprise_Me_data=[US_Presidents_data,Capitals_data,Scientists_data,NBA_Teams_data,NFL_Teams_data]; %data set for surprise me

%initialize varibles
word=''; %intialize variable for word to be generate 
guess=0; %initialize variable for user's guess
check_guess=zeros(length(word),1); %initialize vector that will check if guess is in the word
lives_init=6; %default radio buttons for number of lives is 6
selection_made=0; %user has not yet chosen option from popupmenu
continue_game=1; %state to allow game to continue i.e. has not yet been a win or less
live_selection=0; %user has not yet cosen a radiobutton for number of lives

%initalize GUI

%callback function for radio button group
    function bselection_Callback(source, event)
        if live_selection==0
        switch event.NewValue
            case six_lives %user selects 6 lives
                num_lives=6; %assign 6
                lives_init=6;
            case seven_lives %user selects 7 lives
                num_lives=7; %assign 7
                lives_init=7;
            case eight_lives %user selects 8 lives
                num_lives=8; %assign 8
                lives_init=8;
            case nine_lives %user selects 9 lives
                num_lives=9; %assign 9
                lives_init=9;
        end
        live_selection=1;
        end
        set(number, 'String', num2str(num_lives)); %update static text with selected number of lives
    end

%callback function for popupmenu
    function popup_Callback(hObject, eventdata, handles)
        while selection_made==0 %user has not yet selected option from popupmenu
            switch get(hObject, 'Value')
                case 1 %user selects US Presidents
                    word=char(datasample(US_Presidents_data,1)); %randomly select one element from selected data
                case 2 %user selects State Capitals
                    word=char(datasample(Capitals_data,1)); %randomly select one element from selected data
                case 3 %user selects famous scientists
                    word=char(datasample(Scientists_data,1)); %randomly select one element from selected data
                case 4 %user selects NBA Teams
                    word=char(datasample(NBA_Teams_data,1)); %randomly select one element from selected data
                case 5 %user selects NFL Teams
                    word=char(datasample(NFL_Teams_data,1)); %randomly select one element from selected data
                case 6 %user selects Surprise Me!!!
                    word=char(datasample(Surprise_Me_data,1)); %randomly select one element from selected data
                otherwise 
            end
            
            check_guess=zeros(length(word),1); %update check guess variable so its size reflects the generated word 
            
            %plotting slots where correctly guessed letters will appear
            height=[2 2];
            slot1=plot([0 0.6],height,'b');
            set(slot1,'Visible','off') %make invisible
            slot2=plot([0.7 1.3],height,'b');
            set(slot2,'Visible','off') %make invisible
            slot3=plot([1.4 2],height,'b');
            set(slot3,'Visible','off') %make invisible
            slot4=plot([2.1 2.7],height,'b');
            set(slot4,'Visible','off') %make invisible
            slot5=plot([2.8 3.4],height,'b');
            set(slot5,'Visible','off') %make invisible
            slot6=plot([3.5 4.1],height,'b');
            set(slot6,'Visible','off') %make invisible
            slot7=plot([4.2 4.8],height,'b');
            set(slot7,'Visible','off') %make invisible
            slot8=plot([4.9 5.5],height,'b');
            set(slot8,'Visible','off') %make invisible
            slot9=plot([5.6 6.2],height,'b');
            set(slot9,'Visible','off') %make invisible
            slot10=plot([6.3 6.9],height,'b');
            set(slot10,'Visible','off') %make invisible
            slot11=plot([7 7.6],height,'b');
            set(slot11,'Visible','off') %make invisible
            slot12=plot([7.7 8.3],height,'b');
            set(slot12,'Visible','off') %make invisible
            slot13=plot([8.4 9],height,'b');
            set(slot13,'Visible','off') %make invisible
            slot14=plot([9.1 9.7],height,'b');
            set(slot14,'Visible','off') %make invisible
            
            %want number of slots equal to number of letters in word
            %genereated
            if length(word)==4 %word has 4 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                
            elseif length(word)==5 %word has 5 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                
            elseif length(word)==6 %word has 6 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                
            elseif length(word)==7 %word has 7 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                
            elseif length(word)==8 %word has 8 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                
            elseif length(word)==9 %word has 9 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                set(slot9,'Visible','on') %make visible
                
            elseif length(word)==10 %word has 10 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                set(slot9,'Visible','on') %make visible
                set(slot10,'Visible','on') %make visible
                
            elseif length(word)==11 %word has 11 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                set(slot9,'Visible','on') %make visible
                set(slot10,'Visible','on') %make visible
                set(slot11,'Visible','on') %make visible
                
            elseif length(word)==12 %word has 12 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                set(slot9,'Visible','on') %make visible
                set(slot10,'Visible','on') %make visible
                set(slot11,'Visible','on') %make visible
                set(slot12,'Visible','on') %make visible
                
            elseif length(word)==13 %word has 13 letters in it
                set(slot1,'Visible','on') %make visible
                set(slot2,'Visible','on') %make visible
                set(slot3,'Visible','on') %make visible
                set(slot4,'Visible','on') %make visible
                set(slot5,'Visible','on') %make visible
                set(slot6,'Visible','on') %make visible
                set(slot7,'Visible','on') %make visible
                set(slot8,'Visible','on') %make visible
                set(slot9,'Visible','on') %make visible
                set(slot10,'Visible','on') %make visible
                set(slot11,'Visible','on') %make visible
                set(slot12,'Visible','on') %make visible
                
            end
            selection_made=1; %stop user from being able to make different selction after picking once
        end
    end

%callback function for editbox
    function editbox_Callback(hObject, eventdata, handles)
        if selection_made==1 %ensure that user has selected a word
            if continue_game==1 %ensure that user cannot enter enter guess after game has ended i.e. already have a win or loss
                guess = get(hObject,'String'); %retrieve guess entered in editbox
                
                %check if guessed letter is anywhere in the word
                for i=1:length(word)
                    if word(i)==guess
                        check_guess(i)=1; %record that guessed letter in that spot
                        text(i*.3+(i-1)*.4,2,guess,'HorizontalAlignment','center', 'VerticalAlignment','bottom');
                    end
                end
                
                set(letter_guess,'String','') %"clear" string in edit box
                
                %guess not in word
                check=ismember(word,guess); %see if guess is in the word
                if check==zeros(1,length(word)) %if it is false that the guess appears in the matrix --> false = zeros
                    num_lives=num_lives-1;%one less guess after a wong guess
                    set(number, 'String', num2str(num_lives)); %update static text with new number of lives left
                    
                    %code to plot correct body part based on number of lives
                    %initially chosen
                    if lives_init==6 %user initial selected 6 lives
                        if num_lives==5   %user makes 1 wrong guess
                            fill(x5,y5,[.9,.75,.6],'LineStyle','none'); %make head appear
                        elseif num_lives==4  %user makes 2 wrong guesses
                            set(body,'Color', [.9,.75,.6])
                        elseif num_lives==3  %user makes 3 wrong guesses
                            set(leftarm,'Color', [.9,.75,.6])
                        elseif num_lives==2  %user makes 4 wrong guesses
                            set(rightarm,'Color', [.9,.75,.6])
                        elseif num_lives==1  %user makes 5 wrong guesses
                            set(leftleg,'Color', [.9,.75,.6])
                        elseif num_lives==0  %user makes 6 wrong guesses
                            set(rightleg,'Color', [.9,.75,.6])
                        end
                    end
                    
                    if lives_init==7 %user initial selected 7 lives
                        if num_lives==6   %user makes 1 wrong guess
                            fill(x5,y5,[.9,.75,.6],'LineStyle','none'); %make head appear
                        elseif num_lives==5  %user makes 2 wrong guesses
                            set(body,'Color', [.9,.75,.6])
                        elseif num_lives==4  %user makes 3 wrong guesses
                            set(leftarm,'Color', [.9,.75,.6])
                        elseif num_lives==3  %user makes 4 wrong guesses
                            set(rightarm,'Color', [.9,.75,.6])
                        elseif num_lives==2  %user makes 5 wrong guesses
                            set(leftleg,'Color', [.9,.75,.6])
                        elseif num_lives==1  %user makes 6 wrong guesses
                            set(rightleg,'Color', [.9,.75,.6])
                        elseif num_lives==0 %user makes 7 wrong guesses
                            set(mouth,'Color','k')
                            uistack(mouth,'top')
                        end
                    end
                    
                    if lives_init==8 %user initial selected 8 lives
                        if num_lives==7   %user makes 1 wrong guess
                            fill(x5,y5,[.9,.75,.6],'LineStyle','none'); %make head appear
                        elseif num_lives==6  %user makes 2 wrong guesses
                            set(body,'Color', [.9,.75,.6])
                        elseif num_lives==5  %user makes 3 wrong guesses
                            set(leftarm,'Color', [.9,.75,.6])
                        elseif num_lives==4  %user makes 4 wrong guesses
                            set(rightarm,'Color', [.9,.75,.6])
                        elseif num_lives==3  %user makes 5 wrong guesses
                            set(leftleg,'Color', [.9,.75,.6])
                        elseif num_lives==2  %user makes 6 wrong guesses
                            set(rightleg,'Color', [.9,.75,.6])
                        elseif num_lives==1  %user makes 7 wrong guesses
                            set(lefteye,'Color','k')
                            uistack(lefteye,'top')
                        elseif num_lives==0 %user makes 8 wrong guesses
                            set(righteye,'Color','k')
                            uistack(righteye,'top')
                        end
                    end
                    
                    if lives_init==9 %user initial selected 9 lives
                        if num_lives==8   %user makes 1 wrong guess
                            fill(x5,y5,[.9,.75,.6],'LineStyle','none'); %make head appear
                        elseif num_lives==7  %user makes 2 wrong guesses
                            set(body,'Color', [.9,.75,.6])
                        elseif num_lives==6  %user makes 3 wrong guesses
                            set(leftarm,'Color', [.9,.75,.6])
                        elseif num_lives==5  %user makes 4 wrong guesses
                            set(rightarm,'Color', [.9,.75,.6])
                        elseif num_lives==4  %user makes 5 wrong guesses
                            set(leftleg,'Color', [.9,.75,.6])
                        elseif num_lives==3  %user makes 6 wrong guesses
                            set(rightleg,'Color', [.9,.75,.6])
                        elseif num_lives==2  %user makes 7 wrong guesses
                            set(lefteye,'Color','k')
                            uistack(lefteye,'top')
                        elseif num_lives==1 %user makes 8 wrong guesses
                            set(righteye,'Color','k')
                            uistack(righteye,'top')
                        elseif num_lives==0 %user makes 9 wrong guesses
                            set(mouth,'Color','k')
                            uistack(mouth,'top')
                        end
                    end
                    
                    %code to display incorerct guesses to plot, unique positions
                    %for based on number of lives left so no letters
                    %overlapping
                    if num_lives==8 %there are 8 lives left - note never 9 lives left for wrong guess b/c have already lost one if started at 9
                        text(.8,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==7 %there are 7 lives left
                        text(1.6,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==6 %there are 6 lives left
                        text(2.4,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==5 %there are 5 lives left
                        text(3.2,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==4 %there are 4 lives left
                        text(4,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==3 %there are 3 lives left
                        text(4.8,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==2 %there are 2 lives left
                        text(5.6,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==1 %there are 1 lives left
                        text(6.4,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    elseif num_lives==0 %there are 0 lives left
                        text(7.2,1,guess,'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %show wrong guess on plot
                    end
                end
                
                %user wins game
                if nnz(check_guess)==length(word) %the user has guessed all the letters --> game won
                    text(5,5,'YOU WIN!','Color','green','FontSize',30,'HorizontalAlignment','center') %tell user they've won
                    continue_game=0; %stop user from being able to enter more guesses
                    pause(4)
                    close(f) %close game
                end
                
                %user loses
                if num_lives==0
                    %show all the letters the user didn't guess in red
                    for i = 1:length(word)
                        if check_guess(i)==0 %user did not previously guess that letter
                            text(i*.3+(i-1)*.4,2,word(i),'Color','red','HorizontalAlignment','center', 'VerticalAlignment','bottom'); %display that letter in correct slot
                        end
                    end
                    text(5,5,'YOU LOSE!','Color','red','FontSize',30,'HorizontalAlignment','center') %tell user they've lost
                    continue_game=0; %stop user from being able to enter more guesses
                    pause(4)
                    close(f) %close game
                end
            end
        end
    end
end
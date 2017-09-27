#! /bin/bash
## Forked From https://github.com/joerod/shell/blob/master/GAM_Automation.sh

gam="$HOME/bin/gam/gam" #set this to the location of your GAM binaries

start_date=`date +%Y-%m-%d` # sets date for vacation message in proper formate   

end_date=`date -v+90d +%Y-%m-%d` #adds 90 days to todays date for vacation message

newuser(){
   echo "     Gammit Admin User Selection"
  read -p "Enter email address to admin: " email
    if [[ -z $email ]];
      then echo "Please enter an email address to proceed";
      read -p "Enter email address to admin: " email
    fi  
   }



useradmin(){
while :
do
 clear
 echo "Currently Managing Email: $email"
 echo "1. Set Vacation Message /Remove Forward"
 echo "2. Remove Vacation Message"
 echo "3. Delete Signature"
 echo "4. Check Vacation Message"
 echo "5. Check Group Membership"
 echo "6. Remove From One Group"
 echo "7. Remove From All Groups"
 echo "8. Remove $email from GAL"
 echo "9. Reset Password"
 echo "10. Suspend User"
 echo "11. Offboarding"
 echo "12. Show all calendars"
 echo "13. Mirror $email's Groups to another user"
 echo "14. Forward $email's Emails to another user"
 echo "15. Admin Another User"
 echo "16. Delete $email's Gdrive File by ID" 
 echo "17. Show $email's Team Drives" 
 echo "18. Back to Main Menu" 
 echo "19. Exit"
 echo "20. User info"
 echo "21. Delegate $email to someone else"


 echo "Please enter option [1 - 15]"
    read opt
    case $opt in
    
     1) echo "************ Set Vacation Message / Remove Forward *************";
        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $start_date enddate $end_date 
        echo "Press [enter] key to continue. . .";
        read enterKey;;
        
     2) echo "************ Remove Vacation Message *************";
        $gam user $email vacation off
        echo "Message has been removed press [enter] key to continue. . .";
        read enterKey;;
    
     3) echo "************ Delete Signature ************";
        $gam user $email signature ' ';
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     
     4) echo "************ Current Vacation Message ************";
        $gam  user $email show vacation;
        echo "Press [enter] key to continue. . .";
        read enterKey;;
    
     5) echo "************ Check Group Membership ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |sort )
        for i in $purge_groups
            do
               echo $i
            done;
        echo "Groups have been checked [enter] key to continue. . .";
        read enterKey;;
     
     6) echo "************ Remove From One Group ************";
        read -p "Enter Group name to be removed " group_name
        $gam update group $group_name remove owner $email
        $gam update group $group_name remove member $email
        echo "Group has been removed press [enter] key to continue. . .";
        read enterKey;;
   
     
     7) echo "************ Remove From All Groups ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i
               $gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;
   
        
     8) echo "************ Remove $email from Global Address List (GAL) ************";
        $gam user $email profile unshared
        echo "User is now hidden from the GAL Press [enter] key to continue. . .";
        read enterKey;;
        
     9) echo "************ Reset Password ************";
        randpassword=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 8) #creates random 8 charecter password
        $gam update user $email password $randpassword
        echo "Password has been reset to $randpassword [enter] key to continue. . .";
        read enterKey;;  

     10) echo "************ Suspend  User ************";
        $gam update user $email suspended on
        echo "User is now suspended press [enter] key to continue. . .";
        read enterKey;;

     11) echo "************ Offboarding ************";
        randpassword=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 8)
#        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
#        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $start_date enddate $end_date
        $gam user $email signature '';
        $gam user $email profile unshared
        $gam update user $email password $randpassword
        $gam user $email deprovision
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i            
               $gam update group $i remove member $email
            done;
        echo "All tasks preformed press password has been set to $randpassword [enter] key to continue. . .";
        read enterKey;;

     12) echo "************ Show all calendars ************";
        $gam user $email show calendars
         echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;

     13) echo "************ Mirror $email groups to another user ************";
        read -p  "Enter email address to be mirrored: " mirrored;
        echo $email groups will be mirrored to $mirrored press 1 if this is OK or 2 to exit;
        read answer
        if [ "$answer" -eq "1" ]
         then
              purge_groups=$($gam info user $email |grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
                 for i in $purge_groups
                  do
                     echo adding $mirror to $i group  
                     $gam update group $i add member $mirrored
                  done;
          echo "All groups have been mirrored press [enter] key to continue. . .";
          read enterKey;
        else
             clear
             newuser
         fi;;
         
     14) echo "************ Forward $email's Emails to another user ************";
         read -p  "Enter email address where mail will be forwarded: " forward;
         gam user $email forward on $forward keep
         echo "Emails are bing forwarded press [enter] key to continue. . .";
        read enterKey;;
        
     15) clear
     	echo "************ Admin Another User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;;
    
        
    16)  echo "************ Delete $email's Gdrive File by ID ************";
         read -p  "Enter File ID: " fileid;
         $gam user $email delete drivefile $fileid purge
         echo "File $fileid has been removed press [enter] key to continue. . .";
        read enterKey;;
        
    17) clear
    	echo "************ Show $email's Team Drives ************";
        $gam user $email show teamdrives
         echo "Team Drives Listed [enter] key to continue. . .";
        read enterKey;;

    18)  clear;
    	echo "Back to Main Menu";
		sleep 2;
        mainmenu;;
        
    19) echo "Bye $USER";
        exit 1;; 
        
    20) clear;
        $gam whatis $email
        read enterKey;;
        
    21) clear;
        read -p  "Enter User to Receive Delegation: " usred;
        $gam user $email delegate to $usred
        echo "$email now delegated to $usred [enter] key to continue. . .";
        read enterKey;;
    
        
     *) echo "$opt is an invaild option. Please select option between 1-15 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
}

global(){
while :
do
 clear
 echo "   Global Domain Wide Options"
 echo "************ Global ************";
 echo "1. Delete Message From All" 
 echo "2. Exit"
 echo "3. Print Groups info to CSV" 
 echo "4. Print All Users 2 Step enrolled / enforced" 
 echo "5. Back to Main Menu" 



    read opt
    case $opt in
        
    1) echo "************ Delete Message From All ************";
        read -p "Please enter message ID: " rfc_id
        $gam all users delete messages query rfc822msgid:"$rfc_id" doit
        echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;
        
    2) echo "Bye $USER";
        exit 1;; 
        
    3)  echo "Print all Groups to CSV";
        read -p "Please enter file name to use: " filename
        $gam print groups name description admincreated id aliases members owners managers settings > "$filename".csv
        clear
      	echo "Groups printed to CSV in pwd " & pwd ;
        sleep 2;  
        read enterKey;;
   
     4)  clear;
        $gam print users is2svenrolled is2svenforced
        echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;

        	
    5)  clear;
    	echo "Back to Main Menu";
		sleep 2;
        mainmenu;;
        
        
        
        
        
     *) echo "$opt is an invaild option. Please select option between 1-15 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
}

mainmenu(){
while :
do
 clear 
 echo "************ Gammit By Dennis Mattei ************";
 echo "   M A I N - M E N U"
 echo "1. Admin a single user" 
 echo "2. Global" 
 echo "3. Exit" 


    read opt
    case $opt in

	 1) echo "************ Admin User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;
        useradmin;;
 
    2) echo "************ Admin Global ************";
        global;;
        
      
    3) echo "Bye $USER";
        exit 1;; 
        
        
        
     *) echo "$opt is an invaild option. Please select option between 1-15 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
}

newuser(){
   echo "     gApps Admin"
  read -p "Enter email address to admin: " email
    if [[ -z $email ]];
      then echo "Please enter an email address to proceed";
      read -p "Enter email address to admin: " email;
    fi  
   }
   
clear
mainmenu


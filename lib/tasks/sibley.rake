namespace :sibley do
  namespace :demo do
    desc "Send Content - Make your medication list (SD -9 days)"
    task :medication_list, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, Don't forget to make a list of medications for your “crossmatch” appointment - when you get your pre-surgery bloodwork done at Sibley. Please write down the name, dose, and the amount you take for each medication you’ve used in the last month. For detailed instructions, please use this guide:
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Hi Clare, thanks for the reminder. So I received a form from Sibley to make this list, but I lost it. Do I have to go in and get another form to fill out? 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Great question. You can make your own medication list as long as it includes: full medication name, dose, frequency, route (how you take it), but would you like us to e-mail you the Sibley Patient Medication List document? 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Yeah! Thanks so much
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
You're welcome. Let me know if you have any other questions. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)
    end

    desc "Send Content - Medication Restrictions (SD -8 days)"
    task :medication_restrictions, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Good morning Tami! Clare here. Many medications and herbal supplements can increase your risk of bleeding during and after surgery.  Tomorrow, you should stop taking aspirin, aspirin-based products &  anti-inflammatory drugs (Motrin, Aleve, Daypro, Excedrin, Advil, etc), as well as over-the-counter vitamins and supplements. For a complete list of what is and isn’t safe to keep taking, check out our safe medication list:
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Do you have any questions about this or anything else?
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
What about my insulin?
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
I am going to check with the medical assistant just to confirm and will get back to you shortly.
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Great, thanks!
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
We spoke to Alex and she is going to give you a call within next two hours to give you specific instructions. Is it ok for her to leave a message if she gets your voicemail? 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Yes that is fine. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Great! Let me know if you don't hear from her before tomorrow and I can follow-up. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Thanks! 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Hi Clare, I spoke to Alex and we are all set with my insulin. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)
    end

    desc "Check In - Skin Prep (SD -6 Days)"
    task :skin_prep, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, how are you doing with everything?  Have you been able to pick up your Mupirocin prescription and the Hibiclens soap yet? Please let us know if we can better assist you! 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
I totally forgot! Is it too late?
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
No, it's not too late, but these are extremely important to prep for the procedure and you’ll need to start using them soon. When can you pick it up in the next couple of days? 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
I'll grab it tomorrow. I know Rx is ready at the pharmacy. Where do I get Hibiclens?
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
You should be able to find Hibiclens in the First Aid section of the pharmacy. You'll just need a small bottle. [Tap here](https://shop.riteaid.com/hibiclens-skin-cleanser-antiseptic-antimicrobial-8-fl-oz-236-ml-4708618) to see what the bottle looks like. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Ok, thanks.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
One tip to help you remember to use it, is to leave it out on your bathroom counter with a post-it with the date you need to start using it. I can send over the instructions again. Would that be helpful?   
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Yes that'd be very helpful.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Okay here you go. Tap below to find the skin prep instructions. Is there anything else I can assist you with?
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Nope that's it. Thanks!
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Of course. Have a great day and I'll check-in with you tomorrow see if you picked it up. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Got the Rx + soap!
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Great news! Next on the prep list is to wash your towels and sheets and you'll be all set to start the skin prep in a few days!
      eof
      tami.master_consult.messages.create!(user: clare, text: message)
    end

    desc "HCC (SD -5 Days)"
    task :hcc_messaging, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      kristen = Member.find_by_email!('kkalez@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hey, so my friend who had a surgery done at Sibley before was telling me about something called MyChart. What is this? Should I sign up? 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Hi Tami, Kristen here. I'm one of the team members supporting your PHA Clare today.
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
MyChart is a great tool that allows patients of Sibley to access their health information. With MyChart, you can:
-See limited test results
-View discharge instructions
-Download and share an overview of your visit with your doctor(s) and
  -Allow parents, family members, legal representatives and others access to your medical information
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
Are you interested in signing up for MyChart? If so, I can send the instructions to set up an account your way in the app or email. Which would you prefer? 
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
Please send both. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Great. Here are the Sign Up Instructions:

You will need: the Internet, a current activation code (ask your doctor), your phone number and a personal email address.

  Proxy authorization required. Complete the form at your provider's office.

  Steps:

  1. Open a Web browser, type mychart.hopkinsmedicine.org, then click "Sign Up Now."
  2. Enter your activation code, date of birth, Zip code and phone number, then click "Next."
  3. Create a user id and password, then pick a password secruity question and answer. Enter your personal email address to get MyChart notifications.
  4. Click "Sign In" and you're done! You can use MyChart on a computer, tablet or smartphone. (Download the MyChart app and pick Johns Hopkins Medicine.)
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
I've also sent you an email with these instructions as well. Does that help?
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
Yes. I remember Dr. Unger giving me the activation code. I'll go look for that now.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Sounds great! Is there anything else I can assist you with?
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)

      message = <<-eof
Nope - thanks for all your help Kristen!
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Not a problem. Feel free to message in whenever you have questions. 
      eof
      tami.master_consult.messages.create!(user: kristen, text: message)
    end

    desc "Reminder - Start skin prep tomorrow (SD -4 Days)"
    task :start_skin_prep, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, as a friendly reminder, your special skin prep starts tomorrow. You’ll need to shower with Hibiclens soap once and then use the Mupirocin ointment twice (in the morning and afternoon). To better prepare, be sure to wash your towels as you’ll need a new, clean towel for each shower. Tap below to view the detailed instructions:
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Thanks so much! I am going to start putting that together.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Awesome - that is a great way to be well prepared. How are you feeling about your surgery?
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
I'm a little nervous but I'm hoping things will go smoothly. I feel very well prepared for what's to come.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Feeling nervous is completely normal and you've been doing a great job of keeping on top of things. Please let us know if there is anything else we can do to assist you in the days before your surgery.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)
    end

    desc "Send content - Packing list (SD -3 days)"
    task :packing_list, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, how are you doing? Have you started to pack for your hospital stay? Here is a helpful list of what Sibley recommends you to bring and what’s best to leave at home. Don’t forget your photo ID and comfortable shoes! : 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Thanks so much! I am going to start putting that together.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Awesome - that is a great way to be well prepared. How are you feeling about your surgery?
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
I'm a little nervous but I'm hoping things will go smoothly. I feel very well prepared for what's to come.
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Feeling nervous is completely normal and you've been doing a great job of keeping on top of things. Please let us know if there is anything else we can do to assist you in the days before your surgery.
      eof
      tami.master_consult.messages.create!(user: clare, text: message)
    end

    desc 'Surgery time/date confirmation (SD -2 days)'
    task :surgery_confirmation, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, Dr. Unger notified us that your surgery date has changed to September 15th at 7:30 ActionMailer. You can see the details of your surgery here: 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Look out for an updated calendar invite as well. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Thanks for the update. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)
    end

    desc "Check In - Shower (SD -2 days)"
    task :shower_check_in, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, how was your first shower with Hibiclens soap? A friendly reminder to use the Mupirocin ointment twice a day and to use a fresh towel after each shower. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
It went well! I read the skin prep guide before so I knew exactly what to do. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Awesome! We're happy it went well. Do you have any other questions about any other material we've sent you (i.e. how to prepare your home, packing checklist, skip prep procedure, etc.)? 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Right now I don't, but I will make sure to message in if any come up. 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
Sounds great. Also, just a heads up that I will send you special instructions this afternoon for tomorrow's skin prep. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Talk to you then!
      eof
      tami.master_consult.messages.create!(user: tami, text: message)
    end

    desc "Send content: Day before surgery (SD -2 days)"
    task :day_before_surgery, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Good afternoon Tami! With your surgery date nearing, it’s a very important time to carefully follow your surgeon's instructions. To help with a successful surgery and recovery, we’ve prepared a list of “dos and don'ts” for your use. If you’d prefer to print this list out, we can also send it to you via email. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
Please let us know if you have any questions!
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
      I don't need to print the list out, this should be good for now. Thx 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)
    end

    desc "Reminder - Snack and fasting (SD -1 day 6 pm ET)"
    task :snack_and_fasting, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Hi Tami, I hope you’re feeling ready for tomorrow. A final reminder not to eat or drink anything after midnight tonight (including no smoking, gum, mints, or even life savers).If you eat anything after midnight your surgery may have to be postponed. I’d urge you to have a snack now so you aren’t too hungry in the morning!
      eof
      tami.master_consult.messages.create!(user: clare, text: message)
    end

    desc "Check in - Welcome home (DD)"
    task :welcome_home, [:email] => :environment do |t, args|
      clare = Member.find_by_email!('clare@getbetter.com')
      tami = Member.find_or_create_by_email!(email: args[:email], pha: clare)

      message = <<-eof
Welcome home! We’re so happy to hear that you’ve been discharged from the hospital. How do you feel about being back home?
      eof
      tami.master_consult.messages.create!(user: clare, text: message)

      message = <<-eof
It's feels nice to be back home. I missed my dog!! 
      eof
      tami.master_consult.messages.create!(user: tami, text: message)

      message = <<-eof
We're so glad to hear that. Please let us know if there is anything we can do to make your recovery better, or if we can answer any questions for you. 
      eof
      tami.master_consult.messages.create!(user: clare, text: message)
    end
  end
end

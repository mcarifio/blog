---
Author: Mike Carifio &lt;<mike@carif.io>&gt;
Title: Hiring Economics
Date: 2019-04-02
Tags: #hiring, #economics, #startups, #costs
Blog: [https://mike.carif.io/blog/hiring-economics.html](https://mike.carif.io/blog/hiring-economics.html)
VCS: [https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/bin/../src/hiring-economics.md](https://www.github.com/mcarifio/blog/blob/master/src//home/mcarifio/writing/blog/mike.carif.io/bin/../src/hiring-economics.md)
---

# Hiring Economics

I recently read a [CircleCI blog post about hiring engineers](https://circleci.com/blog/how-we-interview-engineers-at-circleci/). Although informative, I was struct by the data at
the beginning of the post, to wit:

```
Out of any group of 1000 applicants:

250 will pass the initial screen.
117 will pass the hiring manager phone screen.
44 will pass the micro-skills assessment portion of the interview.
7 will pass the macro-skills assessment.
Fewer than 3 will pass the on-site interview and receive offers.
```

Depending on the starting point you choose in the list above, 1000 applicants or 250 applicants, the "success rate" is either 0.003% or 0.012% respectively on the initial pool. How can anyone look at this percentage and not conclude that the selection process is broken, both for the company and the applicants? I certainly did initially after doing some math. Then I found [some Lever benchmarks](https://www.lever.co/blog/new-report-reveals-essential-recruiting-benchmarks-for-startups-and-smbs) that show that CircleCI's experience is consistent with industry standards. 

I don't want to single out the blog author Jeff Palmer, VP of Engineering (whom I don't know) or [CircleCI](https://www.circleci.com/) who had the courage to publish actual numbers and who's engineering blog is both thoughtful and informative. But their stats are head scratchers? If you're a candidate, why would you bother to apply for a job at CircleCI? What strategies would you employ to increase your odds (avoid job boards if at all possible)? Or would you even bother? If a thousand applicants applied, now many more applicants self-filtered themselves out? Another thousand? 

This blog post diverges from most of my others. Mostly I write about this technology or that technique with some happy successful result at the end, tied up with a
bow and with me nodding wisely at the end. I probably sometimes embarrass myself with some "accomplishment" that really isn't that significant, but its significant to me and 
really this is all about _my_ learning and practicing. You, Reader, are just an afterthought. This entry will be a little darker and won't have any nice redeeming story arc.
In this movie, Rocky gets ko-ed and Frodo Baggins falls into Mount Doom. Or worse.

CircleCI's list strikes me as expensive. So does Lever's. But the expense should be measured in time for both candidates and the employer, here CircleCI. My "back-of-the-napkin" analysis is probably similar for most employers. I'll assume -- probably incorrectly -- that no third party recruiters are paid. But generally recruiters only get paid if "their" candidate is hired and lasts some probationary period, typically a quarter. Measuring percentages _from the Employer's perspective_ only states a portion of the cost. And, as we'll see, only a small portion of the cost. Applicants are getting hosed. Big time. They just don't have investment and automation to level the playing field. From the employer's perspective, the more "free" pre-qualification extracted from applicants the most cost effective the employer's recruiting process will be. 


So let's start counting. First, to get 1000 applicants, the applicant pool must apply. Many jobs are never advertised, but let's assume these all are. Three jobs are mentioned, so let's assume three are advertised. It probably takes 20 hours to describe the jobs and post at various job sites. Maybe it takes more to get the descriptions right, calibrated against responses. Even if it took 40 or 50 hours, this number is small compared to the much later numbers coming below. And applicant time dwarfs this number. So, costs thus far in hours: 1) applicants: 0, 2) employer: 20. It also costs to post on job sites and to track applicants with a tracking system. This could easily be a few thousand dollars per posting all told. We'll ignore it all and count only hours spent by people.

The best way to apply for a postings, of course, is to Know Someone, i.e. through a referral from inside the employer. Referrals can be paid, but its rarely more than a percent or two of the starting salary for the hire. Of course, that's good money for the referrer, since it's "found money" and its cost effective for the employer compared to a third party recruiter. But for now, since it's not mentioned, we won't count internal referrals. How long does it take the applicant to apply? Depends. Emailing a resume and a short cover letter probably takes 10-15 minutes. Applying via some job board, can take an hour, especially if you need to rekey in your resume, get contact information right and write a short cover letter. The cost isn't zero. With little justification for the estimate, let's assume the cost is ~500 hours total for the 1000 applicants, but its dispersed across many applicants. The employer isn't shouldering any of this cost. The initial 250 applicants are selected via some matching algorithm through an applicant tracking system. So far: 1) applicants 500 total hours, 2) Employer: 0.

Next is the "initial screen". The new normal here is now either an online programming test, an "indirect test" with something like [Hackerank]() or a "homework assignment" or set of homework assignments. CircleCI, like many of the "new normal" companies, has a "micro-skills take-home problem." Unlike other companies, there appears to be a quick phone screen beforehand and an "person interview" afterwards. I'll assume the manager phone screen is relatively quick, say an hour per candidate. That's 250 hours for the applicants and 250 for the hiring manager. I'm actually surprised CircleCI invests so much time as this stage, but it's a very humane process, as we'll see in the next paragraph with the homework assignment. So far: 1) applicants collectively have consumed 750 hours and 2) the Employer has consumed 250.

It's difficult to predict how long CircleCI's homework assignment can take without seeing it, but I've done several of these kinds of hiring assignments recently and I've averaged about ten hours for each of them. Some problems are harder, and some are more "puzzle" oriented, but inevitably there's a learning curve for something somewhere, such as an unusual module or code package, or some "corner case" algorithm, or even some mainstream technology that you just don't specialize in. I'm probably a little slower than most programmers because I'm deliberate, so let's assume the average developer does a homework assignment in five hours and the employer and applicant review the result for an hour. That means the 117 applicants have just spent ~700 hours of work and the employer has 117. Note that CircleCI is somewhat unusual here in that they imply that each assignment is manually reviewed _with the applicant_. Some employers provide a set of test functions for automated testing. This tell me they run the tests automatically. If yours don't pass, you're filtered out. So it could be that the employer invests nothing on this step. So far: 1) applicants: 1450 hours total, 2) Employer: 250..367. Note that the Employer is consuming four (unpaid) hours of applicant time for every hour it consumes.




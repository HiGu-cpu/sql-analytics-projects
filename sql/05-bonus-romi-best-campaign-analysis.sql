with facebook_campaign_performance as (                                                   
select                                                                                    
'Facebook Ads'as media_source,                                                            
c.campaign_name,                                                                          
SUM(f.spend) as total_spend,                                                              
SUM(f.value) as total_value                                                               
from facebook_ads_basic_daily f                                                           
join facebook_campaign c                                                                  
on f.campaign_id = c.campaign_id                                                          
group by                                                                                  
c.campaign_name                                                                           
),                                                                                        
google_campaign_performance as (                                                          
select                                                                                    
'Google Ads' as media_source,                                                             
campaign_name,                                                                            
SUM(spend) as total_spend,                                                                
SUM(value) as total_value                                                                 
from google_ads_basic_daily                                                               
group by                                                                                  
campaign_name                                                                             
),                                                                                        
all_campaign as (                                                                         
select * from facebook_campaign_performance                                               
union all                                                                                 
select * from google_campaign_performance                                                 
)                                                                                         
select                                                                                    
media_source,                                                                             
campaign_name,                                                                            
total_spend,                                                                              
total_value,                                                                              
(total_value - total_spend)::numeric / nullif(total_spend, 0) as romi                     
from all_campaign                                                                         
where total_spend > 500000                                                                
order by                                                                                  
romi desc                                                                                 
limit 1;                                                                                  
                                                                                          
                                                                                          
with adset_performance as (                                                               
select                                                                                    
c.campaign_name,                                                                          
a.adset_name,                                                                             
SUM(f.spend) as total_spend,                                                              
SUM(f.value) as total_value                                                               
from facebook_ads_basic_daily f                                                           
join facebook_adset a                                                                     
on f.adset_id = a.adset_id                                                                
join facebook_campaign c                                                                  
on f.campaign_id = c.campaign_id                                                          
where c.campaign_name = 'Electronics' --kampanya adi                                      
group by                                                                                  
c.campaign_name,                                                                          
a.adset_name                                                                              
)                                                                                         
select                                                                                    
campaign_name,                                                                            
adset_name,                                                                               
total_spend,                                                                              
total_value,                                                                              
(total_value - total_spend)::numeric /nullif (total_spend, 0) as romi                     
from adset_performance                                                                    
where total_spend > 0                                                                     
order by  romi desc                                                                       
limit 1;                                                                                  
                                                                                          
                                                                                          
                                                                                          
                                                                                          
                                                                                          
                                                                                          

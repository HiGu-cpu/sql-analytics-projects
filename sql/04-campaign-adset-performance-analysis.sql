with facebook_ads_joined as (                                                          
select                                                                                 
f.ad_date,                                                                             
c.campaign_name,                                                                       
a.adset_name,                                                                          
f.spend,                                                                               
f.impressions,                                                                         
f.reach,                                                                               
f.clicks,                                                                              
f.leads,                                                                               
f.value                                                                                
from facebook_ads_basic_daily f                                                        
join facebook_adset a                                                                  
on f.adset_id =a.adset_id                                                              
join facebook_campaign c                                                               
on f.campaign_id = c.campaign_id                                                       
)                                                                                      
select                                                                                 
ad_date,                                                                               
campaign_name,                                                                         
adset_name,                                                                            
spend,                                                                                 
impressions,                                                                           
reach,                                                                                 
clicks,                                                                                
leads,                                                                                 
value                                                                                  
from facebook_ads_joined                                                               
order by                                                                               
ad_date desc,                                                                          
campaign_name,                                                                         
adset_name;                                                                            
                                                                                       
                                                                                       
                                                                                       
                                                                                       
with facebook_ads_joined as (                                                          
select                                                                                 
f.ad_date,                                                                             
'Facebook Ads' as  media_source,                                                       
c.campaign_name,                                                                       
a.adset_name,                                                                          
f.spend,                                                                               
f.impressions,                                                                         
f.reach,                                                                               
f.clicks,                                                                              
f.leads,                                                                               
f.value                                                                                
from facebook_ads_basic_daily f                                                        
join facebook_adset a                                                                  
on f.adset_id =a.adset_id                                                              
join facebook_campaign c                                                               
on f.campaign_id = c.campaign_id                                                       
),                                                                                     
                                                                                       
all_ads_union as (                                                                     
select                                                                                 
ad_date,                                                                               
media_source,                                                                          
campaign_name,                                                                         
adset_name,                                                                            
spend,                                                                                 
impressions,                                                                           
reach,                                                                                 
clicks,                                                                                
leads,                                                                                 
value                                                                                  
from facebook_ads_joined                                                               
union all                                                                              
select                                                                                 
ad_date,                                                                               
'Google Ads' as media_source,                                                          
campaign_name,                                                                         
null as adset_name,                                                                    
spend,                                                                                 
impressions,                                                                           
reach,                                                                                 
clicks,                                                                                
leads,                                                                                 
value                                                                                  
from google_ads_basic_daily                                                            
)                                                                                      
select                                                                                 
ad_date,                                                                               
media_source,                                                                          
campaign_name,                                                                         
adset_name,                                                                            
spend,                                                                                 
impressions,                                                                           
reach,                                                                                 
clicks,                                                                                
leads,                                                                                 
value                                                                                  
from all_ads_union                                                                     
order by                                                                               
ad_date desc,                                                                          
media_source,                                                                          
campaign_name;                                                                         
                                                                                       
                                                                                       
                                                                                       
with facebook_ads_joined as (                                                          
select                                                                                 
f.ad_date,                                                                             
'Facebook Ads' as media_source,                                                        
c.campaign_name,                                                                       
a.adset_name,                                                                          
f.spend,                                                                               
f.impressions,                                                                         
f.reach,                                                                               
f.clicks,                                                                              
f.leads,                                                                               
f.value                                                                                
from facebook_ads_basic_daily f                                                        
join facebook_adset a                                                                  
on f.adset_id = a.adset_id                                                             
join facebook_campaign c                                                               
on f.campaign_id = c.campaign_id                                                       
),                                                                                     
all_ads_union as (                                                                     
select                                                                                 
ad_date,                                                                               
media_source,                                                                          
campaign_name,                                                                         
adset_name,                                                                            
spend,                                                                                 
impressions,                                                                           
clicks,                                                                                
value                                                                                  
from facebook_ads_joined                                                               
union all                                                                              
select                                                                                 
ad_date,                                                                               
'Google Ads' as media_source,                                                          
campaign_name,                                                                         
null as adset_name,                                                                    
spend,                                                                                 
impressions,                                                                           
clicks,                                                                                
value                                                                                  
from google_ads_basic_daily                                                            
)                                                                                      
select                                                                                 
ad_date,                                                                               
media_source,                                                                          
campaign_name,                                                                         
adset_name,	                                                                           
SUM(spend) as total_cost,                                                              
SUM(impressions) as total_impressions,                                                 
SUM(clicks) as total_clicks,                                                           
SUM(value) as total_Conversion_value                                                   
from all_ads_union                                                                     
group by                                                                               
ad_date,                                                                               
media_source,                                                                          
campaign_name,                                                                         
adset_name;                                                                            
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       

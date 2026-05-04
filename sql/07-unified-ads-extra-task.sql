With unified_ads as (                                                                                  
                                                                                                       
-- FACEBOOK                                                                                            
Select                                                                                                 
f.ad_date,                                                                                             
Coalesce(f.url_parameters, '' ) as url_parameters,                                                     
Coalesce(f.spend, 0) as spend,                                                                         
Coalesce(f.impressions, 0)  as impressions,                                                            
Coalesce(f.reach, 0) as reach,                                                                         
Coalesce(f.clicks, 0) as clicks,                                                                       
Coalesce(f.leads, 0) as leads,                                                                         
Coalesce(f.value, 0) as value                                                                          
From facebook_ads_basic_daily f                                                                        
Left Join facebook_adset a                                                                             
on f.adset_id = a.adset_id                                                                             
left join facebook_campaign c                                                                          
on f.campaign_id = c.campaign_id                                                                       
                                                                                                       
)                                                                                                      
select*                                                                                                
from unified_ads;                                                                                      
                                                                                                       
                                                                                                       
                                                                                                       
With unified_ads as ( --Facebook                                                                       
Select                                                                                                 
f.ad_date,                                                                                             
Coalesce(f.url_parameters, '' ) as url_parameters,                                                     
Coalesce(f.spend, 0) as spend,                                                                         
Coalesce(f.impressions, 0)  as impressions,                                                            
Coalesce(f.reach, 0) as reach,                                                                         
Coalesce(f.clicks, 0) as clicks,                                                                       
Coalesce(f.leads, 0) as leads,                                                                         
Coalesce(f.value, 0) as value                                                                          
From facebook_ads_basic_daily f                                                                        
Left Join facebook_adset a                                                                             
on f.adset_id = a.adset_id                                                                             
left join facebook_campaign c                                                                          
on f.campaign_id = c.campaign_id                                                                       
                                                                                                       
Union all --Google                                                                                     
Select                                                                                                 
g.ad_date,                                                                                             
coalesce(g.url_parameters, '') as url_parameters,                                                      
Coalesce(g.spend, 0) as spend,                                                                         
Coalesce(g.impressions, 0) as impressions,                                                             
Coalesce(g.reach, 0) as reach,                                                                         
Coalesce(g.leads, 0) as leads,                                                                         
coalesce (g.clicks, 0) as  clicks,                                                                     
coalesce(g.value, 0) as value                                                                          
from google_ads_basic_daily g                                                                          
)                                                                                                      
select*                                                                                                
from unified_ads;                                                                                      
                                                                                                       
                                                                                                       
With unified_ads as (--Facebook                                                                        
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From facebook_ads_basic_daily                                                                          
                                                                                                       
Union all --Google                                                                                     
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(leads, 0) as leads,                                                                           
coalesce (clicks, 0) as  clicks,                                                                       
coalesce(value, 0) as value                                                                            
from google_ads_basic_daily                                                                            
)                                                                                                      
select ad_date,                                                                                        
case when Lower(Substring(url_parameters from 'utm_campaign=([^&]+)')) ='nan'                          
then null else lower(Substring (url_parameters from 'utm_campaign=([^&]+)'))                           
end as                                                                                                 
utm_campaign,                                                                                          
spend,                                                                                                 
impressions,                                                                                           
reach,                                                                                                 
clicks,                                                                                                
leads,                                                                                                 
value                                                                                                  
from unified_ads;                                                                                      
                                                                                                       
                                                                                                       
With unified_ads as ( --Facebook                                                                       
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From facebook_ads_basic_daily                                                                          
                                                                                                       
Union all -- Google                                                                                    
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(leads, 0) as leads,                                                                           
coalesce (clicks, 0) as  clicks,                                                                       
coalesce(value, 0) as value                                                                            
from google_ads_basic_daily                                                                            
), unified_ads_with_utm as (                                                                           
select ad_date,                                                                                        
case when Lower(Substring(url_parameters from 'utm_campaign=([^&]+)')) ='nan'                          
then null else lower(Substring (url_parameters from 'utm_campaign=([^&]+)'))                           
end as                                                                                                 
utm_campaign,                                                                                          
spend,                                                                                                 
impressions,                                                                                           
reach,                                                                                                 
clicks,                                                                                                
leads,                                                                                                 
value                                                                                                  
from unified_ads                                                                                       
)                                                                                                      
select                                                                                                 
ad_date,                                                                                               
utm_campaign,                                                                                          
SUM(spend) as total_spend,                                                                             
SUM(impressions) as total_impressions,                                                                 
SUM(clicks) as total_clicks,                                                                           
SUM(value) as total_value                                                                              
from unified_ads_with_utm                                                                              
group by ad_date, utm_campaign                                                                         
order by ad_date, utm_campaign;                                                                        
                                                                                                       
                                                                                                       
                                                                                                       
With unified_ads as ( --Facebook                                                                       
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From facebook_ads_basic_daily                                                                          
                                                                                                       
Union all -- Google                                                                                    
Select                                                                                                 
ad_date,                                                                                               
url_parameters,                                                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(leads, 0) as leads,                                                                           
coalesce (clicks, 0) as  clicks,                                                                       
coalesce(value, 0) as value                                                                            
from google_ads_basic_daily                                                                            
), unified_ads_with_utm as (                                                                           
select ad_date,                                                                                        
case when Lower(Substring(url_parameters from 'utm_campaign=([^&]+)')) ='nan'                          
then null else lower(Substring (url_parameters from 'utm_campaign=([^&]+)'))                           
end as                                                                                                 
utm_campaign,                                                                                          
spend,                                                                                                 
impressions,                                                                                           
reach,                                                                                                 
clicks,                                                                                                
leads,                                                                                                 
value                                                                                                  
from unified_ads                                                                                       
),aggregated as (                                                                                      
select                                                                                                 
ad_date,                                                                                               
utm_campaign,                                                                                          
SUM(spend) as total_spend,                                                                             
SUM(impressions) as total_impressions,                                                                 
SUM(clicks) as total_clicks,                                                                           
SUM(value) as total_value                                                                              
from unified_ads_with_utm                                                                              
group by ad_date, utm_campaign                                                                         
)                                                                                                      
select ad_date,                                                                                        
utm_campaign,                                                                                          
total_spend,                                                                                           
total_impressions,                                                                                     
total_clicks,                                                                                          
total_value,                                                                                           
--CTR                                                                                                  
Case when total_impressions = 0 then 0 else total_clicks::numeric /total_impressions                   
end as CTR,                                                                                            
--CPC                                                                                                  
case when total_clicks = 0 then 0 else total_spend /total_clicks end as CPC,                           
--CPM                                                                                                  
case when total_impressions = 0 then 0 else total_spend /total_impressions * 1000 end as CPM,          
--ROMI                                                                                                 
case when total_spend = 0 then 0 else total_value / total_spend end as ROMI                            
from aggregated                                                                                        
order by ad_date, UTM_campaign;                                                                        
                                                                                                       

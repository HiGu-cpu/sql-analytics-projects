select                                                                          
ad_date,                                                                        
campaign_id                                                                     
from facebook_ads_basic_daily                                                   
                                                                                
                                                                                
                                                                                
SELECT column_name                                                              
FROM information_schema.columns                                                 
WHERE table_name = 'facebook_ads_basic_daily';                                  
                                                                                
                                                                                
select                                                                          
ad_date,                                                                        
campaign_id,                                                                    
SUM(spend) as total_spend,                                                      
SUM(impressions) as total_impressions,                                          
SUM(clicks) as total_clicks,                                                    
SUM(value) as total_value                                                       
from facebook_ads_basic_daily                                                   
group by                                                                        
ad_date,                                                                        
campaign_id                                                                     
order by                                                                        
ad_date desc,                                                                   
campaign_id;                                                                    
                                                                                
select                                                                          
ad_date,                                                                        
campaign_id,                                                                    
SUM(spend) as total_spend,                                                      
SUM(impressions) as total_impressions,                                          
SUM(clicks) as total_clicks,                                                    
SUM(value) as total_value,                                                      
-- CPC                                                                          
SUM(spend) / nullif(SUM(clicks), 0) as cpc,                                     
-- CPM                                                                          
(SUM(spend) / nullif(SUM(impressions), 0)) * 1000 as cpm,                       
-- CTR                                                                          
SUM(clicks) /Nullif(SUM(impressions), 0) as ctr,                                
--ROMI                                                                          
(SUM(value) - SUM(Spend)) / nullif(SUM(spend), 0)  as romi                      
from facebook_ads_basic_daily                                                   
group by                                                                        
ad_date,                                                                        
campaign_id                                                                     
order by                                                                        
ad_date desc,                                                                   
campaign_id;                                                                    

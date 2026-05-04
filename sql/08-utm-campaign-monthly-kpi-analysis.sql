With unified_ads as (                                                                                  
Select                                                                                                 
ad_date,                                                                                               
Coalesce(url_parameters, '') as url_parameters,                                                        
Coalesce(spend, 0) AS spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From facebook_ads_basic_daily                                                                          
                                                                                                       
union all                                                                                              
                                                                                                       
select                                                                                                 
ad_date,                                                                                               
Coalesce(url_parameters, '') as url_parameters,                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From google_ads_basic_daily                                                                            
),                                                                                                     
utm_extracted as (                                                                                     
Select                                                                                                 
ad_date,                                                                                               
Case                                                                                                   
When Lower(Substring(url_parameters From 'utm_campaign=([^&]+)')) = 'nan'                              
then Null                                                                                              
Else Lower(Substring(url_parameters From'utm_campaign=([^&]+)'))                                       
end as utm_campaign, spend, impressions, clicks, value                                                 
From unified_ads                                                                                       
),                                                                                                     
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
monthly_aggregated as (                                                                                
select                                                                                                 
date_trunc('month', ad_date)::date as ad_month,                                                        
utm_campaign,                                                                                          
SUM(spend) as total_spend,                                                                             
SUM(impressions) as total_impressions,                                                                 
SUM(clicks) as total_clicks,                                                                           
SUM(value) as total_value                                                                              
From utm_extracted                                                                                     
group by date_trunc('month', ad_date), utm_campaign                                                    
)                                                                                                      
Select                                                                                                 
ad_month, utm_campaign, total_spend, total_impressions, total_clicks, total_value,                     
Case When total_impressions = 0 Then 0 Else total_clicks::numeric / total_impressions End As ctr,      
Case When total_clicks = 0 Then 0 Else total_spend / total_clicks end as cpc,                          
Case When total_impressions = 0 Then 0 Else total_spend / total_impressions * 1000 end as cpm,         
Case When total_spend = 0 Then 0 Else total_value / total_spend end as romi                            
From monthly_aggregated                                                                                
Order By ad_month, utm_campaign;                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
With unified_ads as (                                                                                  
Select                                                                                                 
ad_date,                                                                                               
Coalesce(url_parameters, '') as url_parameters,                                                        
Coalesce(spend, 0) AS spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From facebook_ads_basic_daily                                                                          
                                                                                                       
union all                                                                                              
                                                                                                       
select                                                                                                 
ad_date,                                                                                               
Coalesce(url_parameters, '') as url_parameters,                                                        
Coalesce(spend, 0) as spend,                                                                           
Coalesce(impressions, 0) as impressions,                                                               
Coalesce(reach, 0) as reach,                                                                           
Coalesce(clicks, 0) as clicks,                                                                         
Coalesce(leads, 0) as leads,                                                                           
Coalesce(value, 0) as value                                                                            
From google_ads_basic_daily                                                                            
),                                                                                                     
                                                                                                       
utm_extracted as (                                                                                     
Select                                                                                                 
ad_date,                                                                                               
Case                                                                                                   
When Lower(Substring(url_parameters From 'utm_campaign=([^&]+)')) = 'nan'                              
then Null                                                                                              
Else Lower(Substring(url_parameters From'utm_campaign=([^&]+)'))                                       
end as utm_campaign,                                                                                   
spend,                                                                                                 
impressions,                                                                                           
clicks,                                                                                                
value                                                                                                  
From unified_ads                                                                                       
),                                                                                                     
                                                                                                       
                                                                                                       
monthly_aggregated as (                                                                                
select                                                                                                 
date_trunc('month', ad_date)::date as ad_month,                                                        
utm_campaign,                                                                                          
SUM(spend) as total_spend,                                                                             
SUM(impressions) as total_impressions,                                                                 
SUM(clicks) as total_clicks,                                                                           
SUM(value) as total_value                                                                              
From utm_extracted                                                                                     
group by date_trunc('month', ad_date), utm_campaign                                                    
),                                                                                                     
                                                                                                       
                                                                                                       
                                                                                                       
monthly_metrics as (                                                                                   
                                                                                                       
Select                                                                                                 
ad_month,                                                                                              
utm_campaign,                                                                                          
total_spend,                                                                                           
total_impressions,                                                                                     
total_clicks,                                                                                          
total_value,                                                                                           
total_clicks::numeric / NULLIF(total_impressions,0) AS ctr,                                            
total_spend / NULLIF(total_clicks,0) AS cpc,                                                           
total_spend / NULLIF(total_impressions,0) * 1000 AS cpm,                                               
total_value / NULLIF(total_spend,0) AS romi                                                            
from monthly_aggregated                                                                                
)                                                                                                      
Select                                                                                                 
ad_month,                                                                                              
utm_campaign,                                                                                          
ctr,                                                                                                   
cpm,                                                                                                   
romi,                                                                                                  
                                                                                                       
(ctr - lag (ctr) over (partition by utm_campaign order by ad_month))                                   
/ nullif(lag(ctr) over (partition by utm_campaign order by ad_month),0) *100 as ctr_change_pct,        
                                                                                                       
                                                                                                       
(cpm - Lag(cpm) over (partition by utm_campaign order by ad_month))                                    
 / nullif(Lag(cpm) over (partition by utm_campaign order by ad_month),0) * 100 as cpm_change_pct,      
                                                                                                       
                                                                                                       
(romi - Lag(romi) over (Partition by utm_campaign order by ad_month))                                  
/ nullif(Lag(romi) over (Partition by utm_campaign order by ad_month),0) * 100                         
 as romi_change_pct                                                                                    
                                                                                                       
From monthly_metrics                                                                                   
Order By ad_month, utm_campaign;                                                                       
                                                                                                       
                                                                                                       

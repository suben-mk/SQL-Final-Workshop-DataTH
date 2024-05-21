# SQL Final Workshop - Intro to Data Coding 2024 (DataTH)
**SQL Final Workshop** เป็น Workshop สุดท้ายของคอร์ส Intro to Data Coding 2024 ในส่วนของ SQL (Structured Query Language) ซึ่งจะจำลองสถาณการณ์ทำงานจริง โดยจะได้รับ Requirement จากทีมนึงในองกรค์ (กระต่ายสั่งงาน)

![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/e7882742-fe12-41b5-a44a-798b2238cf7a)
_Requirement จากทีมกระต่ายสั่งงาน_

![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/01086c70-cc62-48ee-8f70-6d3bf67ef456)
_Entity Relationship Diagrams (ER Diagrams)_

## Workflow
1. Explore ข้อมูลที่จะใช้งาน ซึ่งจะเจอข้อมูลที่มีปัญหาดังนี้\
   1.1 Trans_table_compact
     * มี order ถูกยกเลิกและทำให้คอลัมน์ Sales มีค่าเป็นลบ
     * มี order promotion (ฟรี) และทำให้คอลัมน์ Sales มีค่าเป็นศูนย์ (ไม่ตัดข้อมูลทิ้ง)
        
       ![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/df02cdbe-25fc-43c5-ab9c-fa43ddf74a1d)

       ![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/86362de4-53a8-49d1-9c75-b5378ec49f79)

    1.2 Exchange_master
      * มีข้อมูล Null อยู่ใน Table

        ![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/45c59cc8-2192-4090-9596-da4890509e37)

    1.3 Customer_master
      * มีข้อมูล import_date มากกว่า 1 วันต่อ Customer_id ซึ่งต้องการทุกข้อมูล Customer_id ออกมาเฉพาะบรรทัดที่ import_date ล่าสุด

        ![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/d3a43d39-a177-4702-8351-89aaefc66b1e)

    1.4 Product_master
      * มีข้อมูล dubplicate คอลัมน์ Product_ID และ Product_Name ของวันที่ 2024-05-04

        ![image](https://github.com/suben-mk/SQL-Final-Workshop-DataTH/assets/89971741/d6f83102-f118-4dab-adc0-58743440aaba)

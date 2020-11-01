library(AzureStor)

# підключення за допомогою SAS
# дозволені всі resource types та permissions (ss=b&srt=sco&sp=rwdlacupx)
bl_endp_key <- storage_endpoint(endpoint = "https://<ТУТ МАЄ БУТИ НАЗВА>.blob.core.windows.net/", 
                                sas = "<ТУТ МАЄ БУТИ SAS token>")

list_storage_containers(bl_endp_key)

# створити контейнер - папку 1
cont <- storage_container(bl_endp_key, "folder01")
create_storage_container(cont)

list_storage_files(cont)

# створити папку 2-5
create_storage_dir(cont, "folder02/folder03/folder04/folder05")

# у папку 4 добавити файл
storage_upload(cont, src = "some_file.png", dest = "folder02/folder03/folder04/some_file.png") 



# функція, яка створює "n" папок і у парку з номером "to" закидує файл
sas_add_file <- function(endpoint,
                         sas,
                         name = "folder", # найменування папок
                         n = 5,           # загальна кількість папок 
                         to = 4,          # номер папки в яку необхідно завантажити файл
                         file) {          # текстовий рядок наменування файлу в каталогу
        
        # підключення за допомогою SAS
        bl_endp_key <- storage_endpoint(endpoint = endpoint, 
                                        sas = sas)
        
        # найменування папок
        folder_names <- NULL
        
        for (i in 1:n) {
                folder_names[i] <-  paste(c(name, 0, i), collapse = "")
        }
        
        folder4_dest <- gsub(folder_names[to+1], "" ,paste(folder_names[-1], collapse = "/"))
        
        dest <- paste(c(folder4_dest, file), collapse = "")
        
        # створити контейнер - папку 1
        cont <- storage_container(bl_endp_key, folder_names[1])
        create_storage_container(cont)
        
        # створити папку 2-5
        create_storage_dir(cont, paste(folder_names[-1], collapse = "/"))
        
        # у папку 4 добавити файл
        storage_upload(cont, src = file, dest = dest)    
}

# тест функції
sas_add_file(endpoint = "https://<ТУТ МАЄ БУТИ НАЗВА>.blob.core.windows.net/",
             sas = "<ТУТ МАЄ БУТИ SAS token>",
             n = 5,
             to = 4,
             file = "some_file.png")

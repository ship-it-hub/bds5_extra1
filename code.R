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


# функція, яка створює "n" папок і у папку з номером "to" закидує файл
sas_add_file <- function(endpoint,
                         sas,
                         name = "folder", # найменування папок
                         n = 5,           # загальна кількість папок 
                         to = 2,          # номер папки в яку необхідно завантажити файл
                         file) {          # текстовий рядок наменування файлу в каталогу
        
        # підключення за допомогою SAS
        bl_endp_key <- storage_endpoint(endpoint = endpoint, 
                                        sas = sas)
        
        # найменування папок
        folder_names <- NULL
        
        for (i in 1:n) {
                folder_names[i] <-  paste(c(name, 0, i), collapse = "")
        }
        
        folder_path <- paste(folder_names[-1], collapse = "/")
        del_folder <- paste(folder_names[to+1:(n-to)], collapse = "/")
        folder_dest <- gsub(del_folder, "", folder_path)
        dest <- paste(c(folder_dest, file), collapse = "")
        
        # створити контейнер - папку 1
        cont <- storage_container(bl_endp_key, folder_names[1])
        create_storage_container(cont)
        
        # створити папку 2-5
        create_storage_dir(cont, paste(folder_names[-1], collapse = "/"))
        
        # у папку 4 добавити файл
        storage_upload(cont, src = file, dest = dest)    
}

sas_add_file(endpoint = "https://<ТУТ МАЄ БУТИ НАЗВА>.blob.core.windows.net/",
             sas = "<ТУТ МАЄ БУТИ SAS token>",
             n = 5,
             to = 2,
             file = "some_file.png")

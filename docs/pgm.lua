-- Lua start
--===================
--===================
--~~~~~~~~~~~~~~~~~~~
PathToFolder = "./docs"
--~~~~~~~~~~~~~~~~~~~
--====================
--====================
Fpath = PathToFolder
Backward = "readme.md"
Forward = "readme.md"
str = 0

Tbl = {}
Ys = 0;
Ye = 0

local table_md = {}
for line in io.popen("ls " .. PathToFolder, "r"):lines() do
    if string.sub(line, -3) == ".md" then
        -- print(#t + 1 .. " – " .. line)
        table_md[#table_md + 1] = line -- создание таюлицы имен файлов markdown
    end
end

for index, namePage in ipairs(table_md) do
    print("ФАЙЛ ==-----------------=-> " .. namePage)
    str = index
    if -- список исключённых страниц
    namePage ~= "404.md" then

        Fpath = PathToFolder.. "/" .. namePage

        -- init pagination references
        if index ~= 1 then
            Backward = table_md[index - 1]
        end
        if index ~= #table_md and table_md[index+1]~= "404.md" then
            Forward = table_md[index + 1]
            else
                Forward = table_md[index+2]
        end
      ---[[  
        if namePage == "README.md" or namePage == "readme.md" then
            str = " 🏠 "
            Backward = "#"
            Forward = table_md[1]
        end 
        --]]
        

        ------- 01 ------------------

        File = io.open(Fpath, "r")

        --  Cleaning the table of previos data
        Tbl = {}

        for per in File:lines() do
            if per ~= nil then
                table.insert(Tbl, per)
            end
        end

        File:close()

        print('Количество строк в файле: ', #Tbl, "\n")

        ------ Поиск мметок ---------------------------
        for i, v in pairs(Tbl) do

            if string.find(Tbl[i], "ystm_start") then
                print(string.format("Найдено в линии: %i, метка: %s", i, v))
                Ys = i
            end

            if string.find(Tbl[i], "ystm_end") then
                print(string.format("Найдено в линии: %i, метка %s", i, v))
                Ye = i
            end
        end

        ---------- В новую таблицу -------------------------

        NewTbl = {}
        for key, value in pairs(Tbl) do

            if key < Ys or key > Ye then
                table.insert(NewTbl, value)
            end
        end

        --------------------------------------------------

        File2 = io.open(Fpath, "w")

        for _, value in pairs(NewTbl) do

            File2:write(value, "\n")
        end

        -- Шаблон пагинации для файлов `markdown` в единой директории
        Template = "<!--ystm_start-->\n<br>\n\n |назад|".. str .. "|далее| \n |:---|:---:|---:| \n [←←←](" .. Backward ..
                       ")|[ 🔝 ](#)|[→→→](" .. Forward .. ") \n\n <br>\n<!--ystm_end-->\n"

        File2:write(Template)

        File2:close()

        File = io.open(Fpath, "r")
        -- f:write(Template)
        File:seek("set", 0)
        print("\n\nКОНТЕНТ ФАЙЛА\n")
        print(File:read("*a"))

        File:close()
    end
end

print("\n\t THE END !!!\n\n")

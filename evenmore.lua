function main(fichier)
    initscr() --on démare ncurses
    noecho()
    curs_set(0)
    local sizeT = {x = 0,y = 0} --on impose des valeurs nulles pour forcer un calcul au début
    start_color()
    use_default_colors()
    local dataFile = getDataFile()
    local couleurs,boolPositionOrigine = readDataFile(dataFile)
    init_pair(1,couleurs.texte,couleurs.fond)
    init_pair(2,couleurs.fond,couleurs.texte)
    set_color(1)
    local c = "" --le carractère tampon pour l'input de l'utilisateur
    local tabFich = convertFichTable(fichier)
    if not tabFich then
        endwin()
        io.stderr:write("Cannot show '"..fichier.."': No such file\n")
        return nil
    end
    local formatTab = {}
    local actLine = 1 --la ligne à laquelle on commence à lire
    local boolPosition = boolPositionOrigine -- booleen qui sert à savoir si on veut que la position soit affichée en haut à droite de l'écran
    while c~=string.byte("q") and c~=string.byte("Q") and c~=KEY_END do
        local toogleSavePosBool = false --sert à savoir si on doit afficher une update des paramètres
        if sizeChange(sizeT) then
            formatTab = formatage(tabFich,sizeT.x)
            display(formatTab,sizeT,actLine,boolPosition)
        end
        c = getch()
        if c == KEY_UP and actLine > 1 then --déplacement
            actLine = actLine - 1
        elseif c == KEY_DOWN then
            actLine = actLine + 1
        elseif c == KEY_NPAGE then
            actLine = actLine + sizeT.y
        elseif c == KEY_PPAGE then
            actLine = actLine - sizeT.y
        elseif c == KEY_LEFT then --couleur
            editCouleur(couleurs,false,-1)
        elseif c == KEY_RIGHT then    
            editCouleur(couleurs,false,1)
        elseif c == string.byte("n") then
            editCouleur(couleurs,true,1)
        elseif c == string.byte("b") then
            editCouleur(couleurs,true,-1)
        elseif c == string.byte("p") then --affichage de la position
            boolPosition = not boolPosition
        elseif c == string.byte("P") then --on sauvegarde la valeur par défaut de l'affichage de la position
            boolPositionOrigine = boolPosition
            saveData(dataFile,couleurs,boolPositionOrigine)
            toogleSavePosBool = true --on doit afficher que l'on a mis a jour la position par défaut
        end
        if actLine > #formatTab then --si un resize fait que la position n'est plus bonne à répare le truc, //à changer
            actLine = #formatTab
        elseif actLine < 1 then
            actLine = 1
        end
        display(formatTab,sizeT,actLine,boolPosition) --on affiche
        if toogleSavePosBool then
            displayPositionSeting(boolPositionOrigine,sizeT)
        end
    end
    endwin()
    saveData(dataFile,couleurs,boolPositionOrigine)
end
    
function sizeChange(sizeT) --revoie un bouléen informant d'un éventuel changement de l'écrant
    local check = {}
    check.y,check.x = getmaxyx()
    if check.x ~= sizeT.x or check.y ~= sizeT.y then --si il y a changement on met à jour sizeT
        sizeT.x = check.x
        sizeT.y = check.y
        return true
    else
        return false
    end
end


function convertFichTable(fichier) --converti le contenu du fichier dans une table ou chaque ligne correspond à un élément de la table
	local tab={}
	local f=io.open(fichier,"r")
    if not f then return false end --si le fichier n'existe pas on envoie un message disant cela
	local num=1
	local flag=true
	while f and flag do
		local lign=f:read()
		if lign==nil then
			flag=false
		else
			tab[num]=lign
		end
		num=num+1
	end
	if f then f:close() end
	return tab
end

function formatage(tabFich,tailleMax) --permet de découper la table du fichier en dans pour que les grosses lignes s'affichent bien
    local ret = {}
    for i=1,#tabFich do
        ret[#ret + 1] = tabFich[i]
        while sous_formatage(ret,tailleMax) do end --on découpe la nouvelle ligne au besoin
    end
    return ret
end

function sous_formatage(formatTab,tailleMax) --découpe au besoin la dernière ligne de formatTab et renvoie true si ça a été fait
    if #formatTab[#formatTab] <= tailleMax then
        return false
    else
        pointeur = tailleMax+1
        while pointeur > 0 and formatTab[#formatTab]:sub(pointeur,pointeur)~=" " do
            pointeur = pointeur - 1
        end
        if pointeur == 0 then --si il n'y a pas d'endroit où couper la ligne on fait une coupure barbare
            pointeur = tailleMax
        end
        formatTab[#formatTab + 1] = formatTab[#formatTab]:sub(pointeur+1,#formatTab[#formatTab]) -- On met à la ligne suivante ce que la fin de la découpe et on laisse à la ligne une ligne de la bonne taille
        formatTab[#formatTab - 1] = formatTab[#formatTab - 1]:sub(1,pointeur) --on pense au -1 car on a agrandit formatTab
        return true
    end
end

function display(formatTab,sizeT,ligne,boolPosition) --affiche la le texte à partir de la ligne ligne
    clean(sizeT)
    for y=0,sizeT.y-1 do
        if formatTab[ligne+y] then
            mvprintw(y,0,formatTab[ligne+y])
        end
    end
    if boolPosition then
        local pourcent = (ligne/#formatTab)*100
        local mod = 0
        if pourcent < 10 then
            pourcent = tostring(pourcent):sub(1,1)
            mod = 1
        elseif pourcent >= 100 then
            pourcent = "100"
            mod = -1
        else
            pourcent = tostring(pourcent):sub(1,2)
        end
        set_color(2)
        mvprintw(0,sizeT.x-7+mod," "..pourcent.." % ")
        set_color(1)
    end
    refresh()
end

function displayPositionSeting(boolPositionOrigine,sizeT)
    local str
    if boolPositionOrigine then
        str = "on"
    else
        str = "off"
    end
    set_color(2)
    mvprintw(sizeT.y-1,2," By default the position indicator will be "..str.." ")
    set_color(1)
    refresh()
end


function clean(sizeT) --enlève tout ce qui peut nous déranger de l'écrant
    for x=0,sizeT.x+5 do
        for y=0,sizeT.y+5 do
            mvprintw(y,x," ")
        end
    end
end

function readDataFile(file) --permet de lire les informations sur les couleurs et l'état de l'affichage de la position qui sont stockées dans ~/.ASC/evenmorelua/dataFile
    local f = io.open(file,"r")
    local pos = false
    ret = {}
    if f then
        ret.fond = tonumber(f:read())
        ret.texte = tonumber(f:read())
        pos = f:read() == "true" --converti ce que l'on lit en bool
        f:close()
    else
        ret.fond = 0
        ret.texte = 15
        ret.pos = false
        os.execute("mkdir -p ~/.config/ASC/evenmorelua")
    end
    return ret,pos
end

function editCouleur(couleurs,boolFond,mod) --édite les couleurs et boolFond permet de savoir si on change le fond ou le texte; mod vaut +1 ou -1 en fonctions du changement que l'on veut
    if boolFond then
        couleurs.fond = math.floor(couleurs.fond + mod)
        if couleurs.fond < -1 then
            couleurs.fond = 15
        end
        if couleurs.fond > 15 then
            couleurs.fond = -1
        end
    else
        couleurs.texte = math.floor(couleurs.texte + mod)
        if couleurs.texte < 0 then
            couleurs.texte = 15
        end
        if couleurs.texte > 15 then
            couleurs.texte = 0
        end
    end
    init_pair(1,couleurs.texte,couleurs.fond)
    init_pair(2,couleurs.fond,couleurs.texte)
end

function saveData(file,couleurs,boolPosition)
    local p = io.open(file,"w")
    p:write(tostring(couleurs.fond),"\n",tostring(couleurs.texte),"\n",tostring(boolPosition))
    p:close()
end

function getDataFile()
    local f=io.popen("echo $HOME","r") --récupération du nom du sossier maison
    local home=f:read()
    f:close()
    return home.."/.config/ASC/evenmorelua/dataFile"
end

function informations()
    io.stderr:write("This program is meant to nicely display text on a terminal.\n")
    io.stderr:write("Usage : evenmorelua [file]\n")
    io.stderr:write("If file is not specified it will try to read from stdin.\n")
end


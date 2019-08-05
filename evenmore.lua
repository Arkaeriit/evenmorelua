function main(fichier)
    initscr() --on démare ncurses
    noecho()
    curs_set(0)
    local sizeT = {x = 0,y = 0} --on impose des valeurs nulles pour forcer un calcul au début
    local c = "" --le carractère tampon pour l'input de l'utilisateur
    local tabFich = convertFichTable(fichier)
    local formatTab = {}
    local actLine = 1 --la ligne à laquelle on commence à lire
    while c~="q" and c~="Q" do
        if sizeChange(sizeT) then
            formatTab = formatage(tabFich,sizeT.x)
        end
        displayMinimal(formatTab,sizeT,actLine)
        c = getch()
        if c == "KEY_UP" and actLine > 1 then
            actLine = actLine - 1
        elseif c== "KEY_DOWN" then
            actLine = actLine + 1
        end
        if actLine > #formatTab then --si un resize fait que la position n'est plus bonne à répare le truc, //à changer
            actLine = #formatTab
        end
    end
    endwin()
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
        pointeur = tailleMax
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

function displayMinimal(formatTab,sizeT,ligne) --affiche la le texte à partir de la ligne ligne
    clean(sizeT)
    for y=0,sizeT.y-1 do
        if formatTab[ligne+y] then
            mvprintw(y,0,formatTab[ligne+y])
        end
    end
    refresh()
end

function clean(sizeT) --enlève tout ce qui peut nous déranger de l'écrant
    for x=0,sizeT.x-1 do
        for y=0,sizeT.y-1 do
            mvprintw(y,x," ")
        end
    end
end

--function main(fichier) initscr() local sizeT={} sizeT.y,sizeT.x = getmaxyx() displayMinimal(formatage(convertFichTable(fichier),sizeT.x),sizeT,1) getch() endwin() end --test de l'affichage


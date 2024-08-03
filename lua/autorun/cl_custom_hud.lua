-- Vérifie que le script est exécuté côté client
if SERVER then return end

-- Chargement des polices
surface.CreateFont("HUDFont", {
    font = "Roboto",  -- Utilisation d'une police moderne et lisible
    size = 16,
    weight = 500,
    antialias = true
})

-- Fonction pour dessiner des icônes
local function drawIcon(material, x, y, size, color)
    if material then
        -- Dessine l'icône elle-même
        surface.SetDrawColor(color)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(x, y, size, size)
    else
        draw.SimpleText("?", "HUDFont", x + size / 2, y + size / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

-- Chargement des matériaux pour les icônes personnalisées
local heartIcon = Material("materials/heart.png", "smooth")
local moneyIcon = Material("materials/money.png", "smooth")
local salaryIcon = Material("materials/salary.png", "smooth")
local armorIcon = Material("materials/armor.png", "smooth")
local jobIcon = Material("materials/job.png", "smooth")

-- Désactive certains éléments du HUD par défaut mais pas le sélecteur d'armes ni l'icône de micro
hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    local hide = {
        CHudHealth = true,
        CHudBattery = true,
        CHudAmmo = true,
        CHudSecondaryAmmo = true,
        CHudCrosshair = false,  -- Ne pas cacher le crosshair si vous en avez besoin
        CHudWeaponSelection = false,  -- Assurez-vous que le sélecteur d'armes est visible
        CHudVoiceSelf = false  -- Ne pas masquer l'icône de micro pour le joueur
    }
    if hide[name] ~= nil then
        return not hide[name]
    end
end)

-- Fonction pour dessiner le HUD
hook.Add("HUDPaint", "DrawCenteredHUD", function()
    local client = LocalPlayer()

    -- Vérifie si le joueur est vivant
    if not client:Alive() then return end

    -- Coordonnées et dimensions du HUD
    local hudWidth = 600  -- Largeur du HUD
    local hudHeight = 50  -- Hauteur du fond noir
    local hudX = (ScrW() - hudWidth) / 2  -- Calcul pour centrer horizontalement
    local hudY = ScrH() - hudHeight - 20  -- Position ajustée en bas de l'écran
    local iconSize = 24  -- Icônes de taille standard pour clarté

    -- Dessiner le fond noir arrondi derrière le HUD
    draw.RoundedBox(10, hudX, hudY, hudWidth, hudHeight, Color(20, 20, 20, 200))

    -- Espacement entre les sections
    local sectionSpacing = 30  -- Espacement suffisant pour séparer les sections
    local iconTextSpacing = 5  -- Espacement réduit entre icônes et textes

    -- Position de départ pour dessiner les icônes
    local startX = hudX + sectionSpacing

    -- Dessiner l'icône de santé et la valeur
    drawIcon(heartIcon, startX, hudY + (hudHeight - iconSize) / 2, iconSize, Color(255, 80, 80, 255))
    startX = startX + iconSize + iconTextSpacing
    draw.SimpleText(client:Health() .. "%", "HUDFont", startX, hudY + hudHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    startX = startX + 40 + sectionSpacing

    -- Dessiner l'icône d'armure et la valeur
    drawIcon(armorIcon, startX, hudY + (hudHeight - iconSize) / 2, iconSize, Color(80, 150, 255, 255))
    startX = startX + iconSize + iconTextSpacing
    draw.SimpleText(client:Armor() .. "%", "HUDFont", startX, hudY + hudHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    startX = startX + 40 + sectionSpacing

    -- Dessiner l'icône de métier et le nom
    drawIcon(jobIcon, startX, hudY + (hudHeight - iconSize) / 2, iconSize, Color(255, 255, 255, 255))
    startX = startX + iconSize + iconTextSpacing
    draw.SimpleText(client:getDarkRPVar("job") or "Citoyen", "HUDFont", startX, hudY + hudHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    startX = startX + 70 + sectionSpacing

    -- Dessiner l'icône de l'argent et la valeur
    drawIcon(moneyIcon, startX, hudY + (hudHeight - iconSize) / 2, iconSize, Color(50, 255, 50, 255))
    startX = startX + iconSize + iconTextSpacing
    draw.SimpleText("$" .. (client:getDarkRPVar("money") or 0), "HUDFont", startX, hudY + hudHeight / 2, Color(50, 255, 50, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    startX = startX + 80 + sectionSpacing

    -- Dessiner l'icône de salaire et la valeur
    drawIcon(salaryIcon, startX, hudY + (hudHeight - iconSize) / 2, iconSize, Color(255, 255, 100, 255))
    startX = startX + iconSize + iconTextSpacing
    draw.SimpleText("$" .. (client:getDarkRPVar("salary") or 0), "HUDFont", startX, hudY + hudHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)
